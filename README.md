# blockchain-go-client


The application is a simple blockchain client written in go 

Requirements: 

1/ Using Go implement a simple blockchain client – the app should expose API, but only limited to few methods described in Gist https://gist.github.com/dimkouv/d06a1cf3c504f96920f6f57c02f56c53 

2/ Add unit tests

3/ Add Dockerfile to pack the client into the deployable application

4/ Create a /terraform folder and write HCL to deploy the application to AWS ECS Fargate (terraform local state, no need to deploy)

5/ Add README.md file describing what could be added to ensure the application is production ready

6/ Share as GitHub repository with Public access (zip files are not accepted)



(Note #1: I didn't had time to add unit tests as my local go  setup was not allowing me to add them correctly)

(Note #2: The requirement asked a blockchain client but also asked to expose API, I'm a bit confused so I implemented the client only)


##  what could be added to ensure the application is production ready
- Unit tests
- Integration tests
- Deployment emvironments: Alpha, pre-prod, prod
- Adding a deployment strategy to avoid dowtime during a deployemt/update
- Changing the image naming and usage to leveage on the image hash instead of blindly trusting the :latest . This is to avoid security issues where a malicious image was ingested on the image registry. 
