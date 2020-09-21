node {

    checkout scm

    docker.withRegistry('https://registry.hub.docker.com', 'dockerHub') {

      /*  def customImage = docker.build("sadanandrshastri/dockerwebapp")*/
      def customImage = docker.build("customtomcat:${env.BUILD_ID}")

        /* Push the container to the custom Registry */
        customImage.push()
           customImage.push('1.0')
    }
}
