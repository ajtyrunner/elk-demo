provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "eu-central-1"
}

resource "aws_instance" "ec2_instance" {
    ami = "${var.ami_id}"
    count = "${var.number_of_instances}"
    subnet_id = "${var.subnet_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.ami_key_pair_name}"
# Use a provisioner to install and configure the ELK stack 
   provisioner "remote-exec" {
     connection {
      type = "ssh"
      user = "ubuntu"
      host = "${self.public_ip}"
      private_key = file("./mko-test.pem")
      agent = false
      timeout = "2m"
    } 
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y openjdk-8-jre-headless",
      "wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -",
      "sudo apt-get install apt-transport-https",
      "echo \"deb https://artifacts.elastic.co/packages/7.x/apt stable main\" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list",
      "sudo apt-get update && sudo apt-get install elasticsearch",
      "sudo apt-get install filebeat",
      "sudo systemctl enable elasticsearch",
      "sudo systemctl start elasticsearch",
      "sudo apt-get install logstash",
      "sudo systemctl enable logstash",
      "sudo systemctl start logstash",
      "sudo apt-get install kibana",
      "sudo systemctl enable kibana",
      "sudo systemctl start kibana",
      "sudo apt-get install filebeat",
      "sudo systemctl enable filebeat",
      "sudo systemctl start filebeat",
      "sudo chmod -R 0777 /etc/kibana/",
      "sudo chmod -R 0777 /opt/",
      "sudo chmod -R 0777 /etc/logstash/conf.d/",
      "sudo chmod -R 0777 /etc/filebeat/"
    ]
  }


  provisioner "file" {
      source      = "./kibana.yml"
      destination = "/etc/kibana/kibana.yml"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = "${self.public_ip}"
      private_key = file("./mko-test.pem")
    }
  }
  provisioner "file" {
    source      = "./elk-demo.jar"
    destination = "/opt/elk-demo.jar"

  connection {
    type = "ssh"
    user = "ubuntu"
    host = "${self.public_ip}"
    private_key = file("./mko-test.pem")
    }
  }
  provisioner "file" {
    source      = "./example.json"
    destination = "/opt/example.json"

  connection {
    type = "ssh"
    user = "ubuntu"
    host = "${self.public_ip}"
    private_key = file("./mko-test.pem")
    }
  }

  provisioner "file" {
    source      = "./logstash.conf"
    destination = "/etc/logstash/conf.d/logstash.conf"

  connection {
    type = "ssh"
    user = "ubuntu"
    host = "${self.public_ip}"
    private_key = file("./mko-test.pem")
    }
  } 

  provisioner "file" {
    source      = "./start.sh"
    destination = "/opt/start.sh"

  connection {
    type = "ssh"
    user = "ubuntu"
    host = "${self.public_ip}"
    private_key = file("./mko-test.pem")
    }
  }

  provisioner "remote-exec" {
    connection {
     type = "ssh"
     user = "ubuntu"
     host = "${self.public_ip}"
     private_key = file("./mko-test.pem")
     agent = false
     timeout = "2m"
   } 
   inline = [
     "sudo chmod 755 /opt/start.sh",
     "/opt/start.sh",
     "sudo systemctl restart logstash"
   ]
 }  
  
} 