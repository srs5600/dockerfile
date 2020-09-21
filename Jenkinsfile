node {

    checkout scm

    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {

     #def customImage = docker.build("sadanandrshastri/customtomcat")
      def customImage = docker.build("customtomcat:${env.BUILD_ID}")*/

        /* Push the container to the custom Registry */
        customImage.push()
     customImage.push('latest')
    }
}
