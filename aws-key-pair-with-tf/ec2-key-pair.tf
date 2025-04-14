# ---------------------------------------------------
# How To Create An EC2 Key-Pair Using Terraform Code 
#-----------------------------------------------------

# ssh key terraform
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ECS-KP"
  public_key = tls_private_key.rsa.public_key_openssh 
}

resource "local_file" "local-file" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "ECS-KP"
}

# NB
# A KEY_PAIR has two keys, the Public Key and the Private Key.

# - The first snippet (syntax) or resource is going to create two keys, the private key and the public key. 
# - The public key of the key we want to create will be stored in ssh server (public Server) while private key is... 
# .... downloaded to our local machine. 

#  ... According to terraform official documentation, there are so many key-pair syntaxes with different algorithm. So, ..
# ... the algorithm we choose depends on our ssh client such as git, putty etc. For example, the RSA key pair type is for git and the private fille format is .pem. .. 
# ...also, the ED25519 algorithm or key pair type is putty and private key file format is .ppk. So, the <tls_private_key> algoritm... 
# ...that we will choose all depends on our ssh client. 

# - The second syntax is to create a key-pair for ec2 instance.
# * The first attribut (key_name) of the second resource is the name we want to give to our key-pair.
# * The second attribute (public_key) is the public key of the key we want to create. This is because when we create a...
# ...key-pair, its public key is stored in the ssh server (public server) such as aws, while the private key is downloaded to our local machine...
# ...are store in ssh client such git or putty etc. So, the public key here is <tls_private_key.rsa.public_key_openssh>

# The third resource is to create a file in our local machine while the private key of our key will will be store. 
# * The first attribute of the 3rd resource is the content to be stored in it. So, the content is our private key... 
# .... <tls_private_key.rsa.private_Key_pem>. 
# * The second attribute is the file name in which our private key will be stored. 
