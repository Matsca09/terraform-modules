terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

resource "openstack_blockstorage_volume_v2" "volume" {
  count = var.quantity
  name = var.name
  size = var.size
  volume_type = var.volume_type
  region = var.region
}

resource "openstack_compute_volume_attach_v2" "va" {
  count = var.quantity
  instance_id = var.instance[count.index]
  volume_id = openstack_blockstorage_volume_v2.volume.*.id[count.index]
  region = var.region

  # Workaround avoid attachment recreation on each quantity change
  lifecycle {
    ignore_changes = all
  }
}