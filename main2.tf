data "vkcs_kubernetes_clustertemplate" "k8s-template" {
  version = "1.31"
}

# Master node - минимальная рекомендуемая конфигурация
data "vkcs_compute_flavor" "k8s-master-flavor" {
  name = "STD2-2-8"
}

# Worker node - минимальная возможная конфигурация
data "vkcs_compute_flavor" "k8s-node-group-flavor" {
  name = "STD2-1-2"
}

resource "vkcs_kubernetes_cluster" "k8s-cluster" {
  depends_on = [
    vkcs_networking_router_interface.k8s,
  ]
  
  name                = "sokolova-k8s-cluster"
  cluster_template_id = data.vkcs_kubernetes_clustertemplate.k8s-template.id
  master_flavor       = data.vkcs_compute_flavor.k8s-master-flavor.id
  master_count        = 1
  network_id          = vkcs_networking_network.k8s.id
  subnet_id           = vkcs_networking_subnet.k8s.id
  availability_zone   = "GZ1"
  floating_ip_enabled = true
}

resource "vkcs_kubernetes_node_group" "k8s-node-group" {
name       = "sokolova-k8s-node-group"
cluster_id = vkcs_kubernetes_cluster.k8s-cluster.id
flavor_id  = data.vkcs_compute_flavor.k8s-node-group-flavor.id
node_count = 1

 labels {
  key   = "env"
  value = "test"
}

labels {
  key   = "disktype"
  value = "ssd"
}
taints {
       key = "taintkey1"
       value = "taintvalue1"
       effect = "PreferNoSchedule"
   }

}

# Data source для получения списка всех доступных аддонов
data "vkcs_kubernetes_addons" "available" {
 cluster_id = vkcs_kubernetes_cluster.k8s-cluster.id
}

# Data source для получения конкретного аддона cert-manager с указанием версии
data "vkcs_kubernetes_addon" "cert_manager" {
  cluster_id = vkcs_kubernetes_cluster.k8s-cluster.id
  name       = "cert-manager"
  version    = "1.16.3"  # Указываем конкретную версию
}

# Установка cert-manager как аддона
resource "vkcs_kubernetes_addon" "cert_manager" {
  cluster_id = vkcs_kubernetes_cluster.k8s-cluster.id
  addon_id   = data.vkcs_kubernetes_addon.cert_manager.id
  namespace  = "cert-manager"

    depends_on = [
   vkcs_kubernetes_node_group.k8s-node-group
  ]
}

