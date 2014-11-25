# Ruby Quick Start Guide

This guide will walk you through deploying a Ruby application on Deis.

## Usage

deis create sinatra-sample

config:set S3_HOST=deis-store.local3.deisapp.com
config:set S3_BUCKET_NAME=thisismyawesomebucket
config:set S3_ACCESS_KEY_ID=$(deisctl config store get gateway/accessKey)
config:set S3_SECRET_ACCESS_KEY=$(deisctl config store get gateway/secretKey)

git push deis master
curl -s http://sinatra_sample.local.deisapp.com

## Additional Resources

* [Get Deis](http://deis.io/get-deis/)
* [GitHub Project](https://github.com/deis/deis)
* [Documentation](http://docs.deis.io/)
* [Blog](http://deis.io/blog/)
