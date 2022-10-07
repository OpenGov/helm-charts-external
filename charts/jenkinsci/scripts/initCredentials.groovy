#!/usr/bin/env groovy
import groovy.json.JsonSlurperClassic
import java.io.File

import hudson.util.Secret
import jenkins.model.Jenkins

import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import com.cloudbees.plugins.credentials.CredentialsScope
import com.cloudbees.plugins.credentials.SecretBytes
import com.cloudbees.plugins.credentials.domains.Domain
import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl
import org.jenkinsci.plugins.plaincredentials.impl.FileCredentialsImpl
import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl

// Get the credentials store where we're going to save the credentials
def credentialsStore = Jenkins.getInstance().getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

// Load all of the secrets from file
def env = System.getenv()
def secretsFile = new File("${env['JENKINS_HOME']}/init.groovy.d/secrets/secrets.json")
def secrets = new JsonSlurperClassic().parseText(secretsFile.text)

// Add all of the secrets to the credentials store by type
secrets.usernameSshType.each { id, values ->
  def privateKey = new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(values.key)
  def credential = new BasicSSHUserPrivateKey(CredentialsScope.GLOBAL, id, values.username, privateKey, '', '')
  credentialsStore.addCredentials(Domain.global(), credential)
}

secrets.usernamePasswordType.each { id, values ->
  def credential = new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL, id, '', values.username, values.password)
  credentialsStore.addCredentials(Domain.global(), credential)
}

secrets.secretTextType.each { id, secret ->
  def credential = new StringCredentialsImpl(CredentialsScope.GLOBAL, id, '', Secret.fromString(secret))
  credentialsStore.addCredentials(Domain.global(), credential)
}

secrets.secretFileType.each { id, secret ->
  def credential = new FileCredentialsImpl(CredentialsScope.GLOBAL, id, '', id, SecretBytes.fromString(secret))
  credentialsStore.addCredentials(Domain.global(), credential)
}

// Persist the secrets to Jenkins
Jenkins.getInstance().save()
