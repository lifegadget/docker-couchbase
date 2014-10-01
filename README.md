#Couchbase Docker Container
> lifegadget/docker-couchbase [[container](https://registry.hub.docker.com/u/lifegadget/docker-couchbase/)]

## Introduction

This is meant as a way to provide Couchbase Enterprise and Community servers within a Docker container. This container borrows ideas from  [ncolomer/docker-templates](https://github.com/ncolomer/docker-templates), [dockerimages/couchbase](), and [dustin/couchbase](https://gist.github.com/dustin/6605182) and was designed to work well with the other LifeGadget containers to become part of a full-stack implementation:

- NGINX Webserver - [lifegadget/docker-nginx](https://github.com/lifegadget/docker-nginx)
- PHP FPM Server - [lifegadget/docker-php](https://github.com/lifegadget/docker-php)

Feel free to use and we are happy to accept PR's if you have ideas you feel would be generally reusable.

## Usage ##


- **Prerequisites**

	On the host machine you need to override *memlock* and *nofile* limits to make Couchbase run correctly. You do this by adding the following lines at the end of the `/etc/init/docker.conf` file:

		limit memlock unlimited unlimited
		limit nofile 262144

	Finally, restart the Docker daemon: `/etc/init.d/docker restart`.

- **Basic usage:**
	
		sudo docker run -d lifegadget/docker-couchbase

	This will get you up and running with an empty database with a single Couchbase node. 

	- [php.ini](https://github.com/lifegadget/docker-php/blob/master/resources/php.ini)
	- [php-fpm.conf](https://github.com/lifegadget/docker-php/blob/master/resources/php-fpm.conf)

	This configuration, in summary, gives you a "pool" listening on port 9000 with it's root content pointed to the container's `/app/content` directory. In this basic configuration, there are two PHP scripts provided out-of-the-box which are meant just to give you a sense for the environment/configuration:

	- `index.php` - this provides a print out of PHP's well known `phpinfo()` function
	- `server.php` - this provides a listing of all `$_SERVER` variables passed into FPM

	If you're using this in conjunction with `lifegadget/docker-nginx` then these two PHP scripts will be available off the "fpm" root (aka, `http://localhost/fpm`). Enjoy you're done ... but you're going to probably at least put in your own content, right? Turn to the advanced section (which isn't really that advance for that and more).

- **Advanced usage:**

	You can progressively take over responsiblities for various parts of the configuration, including:

	- `content` - this is more than likely the place where you'll want to take control and specify a directory on the host system which represents the root of the content for your site. This will be internally hosted at `/app/content`. So let's assume for a moment that your host machine has a directory called `/container/content` you would then add the following parameter to your run command:
	
		````bash
		-v /container/content:/app/content
		````

		Now your script content is live. That means that handy index.php and server.php we talked about are gone but I'm sure you have far more interesting things you'd like to be doing. 
	
	- `conf.d` - you can take over the `conf.d` directory which is used to specify fpm "pools"; any file with named *.conf will be picked up and used as part of the FPM configuration. Choosing this will mean that the [default service


# OLD #
### Automated Image for Docker

> Developed by [LifeGadget](http://lifegadget.co) for [LifeGadget](http://lifegadget.co) but anyone is welcome to use

## Usage ##

- **Run**

	````bash
	sudo docker run -d \
		-v /host/mount/point:/data -e CB_PASSWORD=password \
		-p 11210:11210 -p 8091:8091 -p 8092:8092 \
		--name=COUCHBASE -t lifegadget/docker-couchbase
	````

	Running will force a download and build of the *docker-couchbase* environment to a locally executable container. After that the image will reside locally and the cached reference can be used. This cache, however, is not that useful because once started with `run` we will then just be manageing the resultant container with the commands below in the manage section.

	Assumptions/Comments:

	- 	**Data**. This installation of Couchbase installs and runs Couchbase as a daemon but the file system that data is stored on should be provided by the host container. You can point anywhere on the host you like but make sure that whatever is passed as the first parameter to the `-v` switch (aka, before the colon) is a valid filesystem on localhost.
	- 	**Username**. Currently this is not *settable* and just defaults to 'Adminstrator'
	- 	**Password**. Please set this password (e.g., the `CB_-_PASSWORD` environment variable passed in) to whatever you like and make sure to store it in a safe place as changing this isn't fun without the existing password.

- **Manage**

	- Process Execution	

		````bash
		# Start
		sudo docker start COUCHBASE
		# Stop
		sudo docker stop COUCHBASE
		# Restart
		sudo docker restart COUCHBASE
		````

	- Information

		````bash
		# Container details
		sudo docker inspect COUCHBASE
		# Logging/STDOUT of container
		sudo docker logs COUCHBASE
		````

## Details ##

For those that care about what lies within the container ...

- Couchbase will be installed to `/opt/couchbase` (the default location in Ubuntu)
- The installer will insert a bootstrap loader for couchbase at `/usr/sbin/couchbase`

 
## Versions ##

All versions of Couchbase use a base image of Ubuntu (currently 14.04). The list of available Couchbase 'versions' is broken up into both the build number and whether the build is 'community' or 'enterprise'. Currently the only available versions are Enterprise releases but in the future a branch for community will be created:

<table>
	<tr>
		<th>label</th>
		<th>vlabel</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>latest</td>
		<td>3.0.beta</td>
		<td>Couchbase Enterprise - Beta Release</td>
   </tr>
	<tr>
		<td>stable</td>
		<td>2.5.1</td>
		<td>Couchbase Enterprise 2.5.1 - Production Release</td>
   </tr>
</table>

## License

**docker-couchbase** was based on, but heavily modified from, [Dockerfile](https://gist.github.com/dustin/6605182). The rewrite was done by [Ken Snyder](http://ken.net) and made available under the under the [MIT license](https://github.com/broccolijs/broccoli/blob/master/LICENSE.md).