# This Dockerfile is the default one that Docker will look for building an image. It will be use for production
# In production, the idea will be to have 2 phases and so 2 base images from which we will create our images

# Build Phase
# start from node alpine, copy the package.json file and install the dependencies and then run the BUILD command

# Run Phase
# start from nginx to have a server for static asset, use the result of the build from the previous phase and start the nginx server

# ps: in production, we DO NOT need any dependencies. These have been used to construct our build but once we have it we don't need them anymore. Inside the created build directory we will have our index, main.js and all other required files and that's it. so we can ditch the dependencies (node_modules) that won't be used!!

FROM node:alpine as builder
# with as keyword we tag this phase and call it builder! this is necessary as we need 2 distinct phases
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx
# this EXPOSE is specifically for elasticbeanstalk for it to know that we need to map our external port to the port 80 inside Docker
EXPOSE 80
# here we don't need a tag. the fact of calling FROM indicates to Docker that this is another phase
COPY --from=builder /app/build /usr/share/nginx/html
# the --from command means we want to copy sthg from the phase called builder and then we specify the source and the destination paths - the destination is in the nginx docker documentation

# we do not sepcify the start nginx command at the end as by default this is the command that comes with the nginx base image
