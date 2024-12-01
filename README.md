# Configuração do Redis com AWS ElastiCache usando Terraform

Este repositório contém a configuração para criar um grupo de replicação Redis em múltiplas zonas de disponibilidade (Multi-AZ) na AWS, utilizando o ElastiCache. A configuração também inclui grupos de sub-redes e regras de segurança necessárias.

## Requisitos

- [Terraform](https://www.terraform.io/downloads.html) v1.x ou superior
- Credenciais AWS configuradas em sua máquina local ou ambiente CI/CD
- Permissões adequadas para criar recursos na AWS, como VPC, Subnets, Security Groups e ElastiCache.

## Estrutura de Arquivos

- `redis.tf`: Contém a definição dos recursos do ElastiCache Redis, grupos de sub-rede e regras de segurança.
- `data.tf`: Obtém dados de recursos existentes da AWS, como a VPC e as sub-redes.