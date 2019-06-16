What ?
This repo's shell file lets you create aws s3 bucket hosting a static website.

Requirements:
- AWS credentials & appropiate Authorizations.
- aws cli tool.


Usage:
- Test your current website folder already by nginx docker:
```sh
docker run --rm --name=tnginx -v /path/to/my/website:/usr/share/nginx/html -p 8080:80 nginx
```
- Now hit your localhost:8080
- If it runs, your website is good to go.
- If needed, change the variables in staticwebsitecreator.sh (needed by the aws s3 bucket hosting)
    - INDEX_FILE : default value: "index.html" 
        - serves as default file that opens for your static website folder.
    - ERROR_FILE : default value: "error.html" 
        - serves as default file that opens for your static website folder in case of error happens.    

- Pass these variables needed for the script to run as command line args.
```sh
bash staticwebsitecreator.sh <bucketname> <aws-region> <mywebsite-folder> 
```
- Goto the website url name as shown in output by the script file.


Srcs:
- https://docs.aws.amazon.com/AmazonS3/latest/user-guide/static-website-hosting.html
- https://medium.freecodecamp.org/how-to-host-a-website-on-s3-without-getting-lost-in-the-sea-e2b82aa6cd38
- https://github.com/aws/aws-cli/issues/2779
