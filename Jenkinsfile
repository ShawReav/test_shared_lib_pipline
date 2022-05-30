#!groovy

node {
    
    // -------------------------------------------------------------------------
    // Defining Org Variables
    // -------------------------------------------------------------------------
	
   def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
   def SF_INSTANCE_URL = env.SF_INSTANCE_URL ?: "https://login.salesforce.com"
   def SF_USERNAME=env.SF_USERNAME
   def toolbelt = tool 'toolbelt'
    
    def SERVER_KEY_CREDENTIALS_ID=env.SERVER_KEY_CREDENTIALS_ID
    def DEPLOYDIR='force-app'
    def SF_DELTA_FOLDER='DELTA_PKG'
    def TEST_LEVEL= env.TEST_LEVEL
    
	
    def DEPLOYMENT_TYPE=env.DEPLOYMENT_TYPE // Incremental Deployment = DELTA ; Full Deployment = FULL
    def SF_SOURCE_COMMIT_ID=env.SOURCE_COMMIT
    def SF_TARGET_COMMIT_ID=env.TARGET_COMMIT
    
    //Defining SFDX took kit path against toolbelt
    


    // -------------------------------------------------------------------------
    // Check out code from source control.
    // -------------------------------------------------------------------------
    @Library("shared-library") _
    stage('checkout source') {
        checkout scm
    }


    // -------------------------------------------------------------------------
    // Run all the enclosed stages with access to the Salesforce
    // JWT key credentials
    // -------------------------------------------------------------------------

 	withEnv(["HOME=${env.WORKSPACE}"]) {	
	echo "workspace directory is ${workspace}"
	    withCredentials([file(credentialsId: SERVER_KEY_CREDENTIALS_ID, variable: 'server_key_file')]) {
		// -------------------------------------------------------------------------
		// Authenticate to Salesforce using the server key.
		// Installing SF Powerkit Plugin
		// -------------------------------------------------------------------------
		
		stage('Update powerkit'){
			
			powerkit
		    }
		stage('Authorize to Salesforce') {
			
				authorize
			
		}
		 
		// -------------------------------------------------------------------------
		// Creating Delta Package with the changes.
		// -------------------------------------------------------------------------

		stage('Create_Delta_Package') {
      			createDeltaPkg
		}

		// -------------------------------------------------------------------------
		// Validating Stage.
		// -------------------------------------------------------------------------

		stage('Package_Validation') {
      			pkgValidation
        	}
		    
		 stage('Package_Deployment') {
      			pkgDeployment
        	}
		// -------------------------------------------------------------------------
		// Deploy metadata and execute unit tests.
		// -------------------------------------------------------------------------

		//stage('Deploy and Run Tests') {
		//    rc = command "${toolbelt}/sfdx force:mdapi:deploy --wait 10 --deploydir ${DEPLOYDIR} --targetusername UAT --testlevel ${TEST_LEVEL}"
		//    if (rc != 0) {
		//	error 'Salesforce deploy and test run failed.'
		//    }
		//}
	    }
	}
}

def command(script) {
    if (isUnix()) {
        return sh(returnStatus: true, script: script);
    } else {
		return bat(returnStatus: true, script: script);
    }
}
