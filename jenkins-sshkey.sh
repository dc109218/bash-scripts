JENKINS_HOME=/var/lib/jenkins
export JENKINS_HOME=/var/lib/jenkins

ssh-keygen -t rsa -C "jenkins" -m PEM -P "" -f /var/lib/jenkins/.ssh/id_rsa

ssh-copy-id -i /var/lib/jenkins/.ssh/id_rsa ubuntu@remoteserverip

# mac machine generate
ssh-keygen -t rsa -b 4096 -m PEM

# pub key
# /var/lib/jenkins/.ssh/id_rsa
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMFfni16pqiSgZBM76nQlQQtiWH1i9ml8PzLQ+1F9lqGXA8Vo3MNPzFNQbTMEcZZpzRLas0egqT9LKwHLsyJJON/rN1LXcR1gm6dq+3M+bKqZuHGEWlHlqaUa9OAosuC/3ANNXlox+IhLQh4DfjsiQt1VcmKjQ9877ya4KjmEhA+IotJIn883fgfdQaM9dIEEu3DNiLVEatiZc7fSgqGR7Xv8EmIqIqcM1ui+ufHXCUHubrAdAlPnCKwnLioLQ1/O9E/U6e/bEXvPJe+IGFYLuapfDDvcAC3Vfu4dzFztMtwt9s3E+l0ufST21rJ6NYZ3US7/0PZCDDYoemiJBeevj jenkins

