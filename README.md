This repo's shell file lets you create aws s3 bucket as a static website.
You need to be logged in with your aws s3 credentials & must have rights to do so.

Example:
Pass these variables needed for the script to run as command line args.
```sh
bash staticwebsitecreator.sh <bucketname> <aws-region> <mywebsite-folder> 
```


Test your website already by nginx:
```sh
docker run --rm --name=tnginx -v /path/to/my/website:/usr/share/nginx/html -p 8080:80 nginx
```
Now hit your localhost:8080


Srcs:
- https://docs.aws.amazon.com/AmazonS3/latest/user-guide/static-website-hosting.html
- https://medium.freecodecamp.org/how-to-host-a-website-on-s3-without-getting-lost-in-the-sea-e2b82aa6cd38
- https://github.com/aws/aws-cli/issues/2779
