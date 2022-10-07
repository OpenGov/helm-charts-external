#!/usr/bin/env groovy
// For debugging this file, see the Jenkins server pod instance logs in Kubernetes

import hudson.plugins.git.*
import hudson.triggers.TimerTrigger;

import jenkins.model.*
import org.jenkinsci.plugins.workflow.cps.*
import org.jenkinsci.plugins.workflow.flow.*
import org.jenkinsci.plugins.workflow.job.*

import javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration

def createRespositoryRootJob = { repository ->
  def (repoUrl, seedBranch) = repository.split(';') + 'master'
  def repoUri = new URI(repoUrl)
  def jobName = "${repoUri.path.split('/').last()}-initialize-pipeline-root"

  // https://github.com/jenkinsci/git-plugin/blob/master/src/main/java/hudson/plugins/git/GitSCM.java#L148
  def ciRepoSCMDefinition = GitSCM.createRepoList(repoUrl, 'github')
  def scm = new GitSCM(ciRepoSCMDefinition, [new BranchSpec(seedBranch)], false, [], null, null, [])
  def job = Jenkins.getInstance().createProject(WorkflowJob.class, jobName)

  def script = """
    @Library('OGJenkinsLib@1.4.0') _

    node {
      ogJenkins.createRootPipeline('${repoUri.path.split('/').last()}')
    }
  """
  job.setDefinition(new org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition(script, true))

  job
}

def env = System.getenv()

// The repositories.txt contains a list of Git repository URLs.
// A seperate GitHub URL must appear on a different line.
// The default branch to have jenkins monitor can be specified after
// the Git URL with a semicolon.
//
// Example:
//    https://github.com/OpenGov/OTH.git                  # Defaults to monitoring master branch
//    https://github.com/Chili-Man/DelphiusApp.git;ninja  # Defaults to monitoring ninja branch
def repositories = new File("${env['JENKINS_HOME']}/init.groovy.d/repositories.txt").text.split('\n')

// create repository root jobs and run
repositories.collect(createRespositoryRootJob).each {
  it.scheduleBuild2(0)
}

// reload instance once all seed jobs have ran
def completed = []
Jenkins.getInstance().getExtensionList(FlowExecutionListener.class).add(new FlowExecutionListener() {
  public void onCompleted(FlowExecution execution) {
    def pipelineName = execution.getOwner().getUrl().split('/')[1]

    completed << pipelineName

    if (completed.size() == (repositories.size() * 2)) {
      Jenkins.getInstance().reload()
    }
  }
})

// Disable Job DSL script approval
GlobalConfiguration.all().get(GlobalJobDslSecurityConfiguration.class).useScriptSecurity=false
GlobalConfiguration.all().get(GlobalJobDslSecurityConfiguration.class).save()
