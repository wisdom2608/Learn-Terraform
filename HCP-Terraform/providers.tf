terraform { 
  cloud { 
    organization = "wisdomtech" 

    workspaces { 
      name = "dev" 
    } 
  } 
}