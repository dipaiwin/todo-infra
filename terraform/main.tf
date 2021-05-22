provider "google" {
  credentials = file("cred/cred.json")
  project     = "todo-314512"
  region      = "us-west1"
}

resource "google_compute_address" "todo-infra" {
  name = "todo-infra"
  network_tier = "STANDARD"
}

resource "google_compute_instance" "default" {
  name         = "todo-vm-1"
  machine_type = "e2-micro"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
      size = "10"
    }
  }

  metadata_startup_script = "sudo apt-get update; sudo apt upgrade"
  metadata = {
    ssh-keys = "root:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOcyWaz2cDBUNDjEdGM1MtP39GAf4itJVryzCb+PJ6GO mitya@MacBook-Pro-Dmitrij.local"
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.todo-infra.address
      network_tier = "STANDARD"
    }
  }
}

output "ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
