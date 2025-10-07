# Развертывание Kubernetes Cluster

1. Создание ресурсов vk-cloud
Для задания были созданы: сеть, роутер, подсеть, инстанс Kubernetes cluster, Kubernetes node-group и аддон cert-manager.

## 🚀 Быстрый старт

### 1. Клонирование репозитория

```bash
git clone https://github.com/somebodyaroundthere/k8s_vkcloud_terraform.git
cd k8s_vkcloud_terraform
```

### 2. Настройка переменных

измените переменные на те, которые вам нужны в файлах secret.tfvars и variables.tf

### 3. Инициализация и развертывание

```bash
# Инициализация Terraform
terraform init

# Просмотр плана развертывания
terraform plan -var-file="secret.tfvars"

# Развертывание инфраструктуры
terraform apply -var-file="secret.tfvars"
```
### 4. Создание самоподписанного сертификата

После успешного развертывания выполните:

```bash
#Сохраните файл конфигурации кластера, измените на него права и добавьте путь к нему в переменную
sudo chmod 0600 configuration.yaml
$env:KUBECONFIG=../../configuration.yaml
#Проверьте подключение к кластреру
kubectl cluster-info
#Ожидаемый вывод:
#Kubernetes control plane is running at...
#CoreDNS is running at...
#Создайте сертификат
kubectl apply -f test-resources.yaml
#Проверьте его с помощью describe
kubectl describe certificate -n cert-manager-test
```

## 📁 Структура проекта

```text
mysql-database-terraform/
├── main2.tf             # Основная конфигурация Terraform
├── variables.tf         # Определение переменных
├── provider.tf          # Настройка провайдера VK Cloud
├── network.tf           # Конфигурация сети
├── test-resources.yaml  # Манифест создания самоподписанного сертификата
```
