resource "null_resource" "kubeconfig" {

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "./wait-for.sh ${aws_eip.master.public_ip}:6443 -t 1200 -- echo \"Cluster Ready\""
    working_dir = "${path.module}/resources"
  }

  connection {
    host        = aws_eip.master.public_ip
    user        = var.cluster_name
    private_key = tls_private_key.master.private_key_pem
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /home/${var.cluster_name}/.kube/config ]; do sleep 1; done",
      "export KUBECONFIG=/home/${var.cluster_name}/.kube/config",
      "kubectl config set-cluster kubernetes --server=https://${aws_eip.master.public_ip}:6443",
    ]
  }

  provisioner "local-exec" {
    command     = "scp -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\" -i master.key ${var.cluster_name}@${aws_eip.master.public_ip}:/home/${var.cluster_name}/.kube/config kubeconfig"
    working_dir = path.root
  }
}

data "local_file" "kubeconfig" {
  filename   = "${path.root}/kubeconfig"
  depends_on = [null_resource.kubeconfig]
}
