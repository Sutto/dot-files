[[ -s "$HOME/.aws_keys" ]] && . "$HOME/.aws_keys"

export JAVA_HOME="$(/usr/libexec/java_home)"
export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
export AWS_RDS_HOME="/usr/local/Cellar/rds-command-line-tools/1.10.003/libexec"
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
