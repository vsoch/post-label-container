FROM golang:bullseye as gobase

# docker build -t ghcr.io/vsoch/post-label-container .

RUN go install github.com/google/go-containerregistry/cmd/crane@latest

LABEL "com.github.actions.name"="Post Container Label"
LABEL "com.github.actions.description"="Add labels to a container post build"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="blue"

WORKDIR /code 
COPY entrypoint.sh /code/entrypoint.sh
ENTRYPOINT ["/code/entrypoint.sh"]

