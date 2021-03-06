resource "digitalocean_loadbalancer" "platzidemo" {
  name = "devops-html-lb-v2"
  region = "nyc3"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 3000
    target_protocol = "http"
  }

  healthcheck {
    port = 3000
    protocol = "http"
    path  = "/"
  }

  droplet_tag = "${digitalocean_tag.platzidemo.name}"
}

# Create a new tag
resource "digitalocean_tag" "platzidemo" {
  name = "devops-html"
}

# Create a new Web Droplet in the nyc3 region
resource "digitalocean_droplet" "platzidemo" {
  count  = 2
  image  = "${var.image_id}"
  name   = "devops-demo-v2"
  region = "nyc3"
  size   = "512mb"
  ssh_keys = [21998511]
  tags   = ["${digitalocean_tag.platzidemo.id}"]

  lifecycle {
    create_before_destroy = true
  }
  provisioner "local-exec" {
    command = "PING -n 100 127.0.0.1>nul"
  }

  user_data = "${file("user-data.web")}"
}
