# CLI MikroTik

## Atalhos no CLI

- **CTRL + L** → Limpa o terminal
- **F5** → Limpa a tela
- **CTRL + D** → Logout
- **CTRL + V** → Cola nas versões mais recentes
- **CTRL + K** → Limpa do cursor até o fim da linha
- **CTRL + C** → Interrompe um comando em execução

---

## Listar IPs das interfaces
Para visualizar os endereços IP configurados em cada interface:

```bash
ip address print
```

### Exemplo de Saída:
```bash
Flags: X - disabled, I - invalid, D - dynamic 
#   ADDRESS            NETWORK         INTERFACE                                                                                     
0 D  192.168.88.133/24  192.168.88.0    ether1                                                                                        
1    192.168.18.1/24    192.168.18.0    ether1   
```

---

## Adicionar IP a uma interface
Para adicionar um endereço IP a uma interface:

```bash
ip address add address=192.168.18.1/24 interface=ether1
```

---

## Remover um IP de uma interface
Substitua `N` pelo ID do IP listado no comando `ip address print`.

```bash
ip address remove numbers=N
```

---

## Desabilitar um IP de uma interface
Para desativar um endereço IP sem removê-lo:

```bash
ip address disable numbers=N
```

---

## Desfazer a última alteração
Caso tenha feito alguma configuração errada, use:

```bash
undo
```

---

## Adicionar um cliente DHCP
Para configurar a interface `ether1` para receber um IP dinâmico via DHCP:

```bash
ip dhcp-client add interface=ether1
```

Verifique se o cliente DHCP foi configurado corretamente:

```bash
ip dhcp-client print
```

### Exemplo de Saída:
```bash
Flags: X - disabled, I - invalid, D - dynamic 
#   INTERFACE   USE-PEER-DNS ADD-DEFAULT-ROUTE STATUS       ADDRESS
0   ether1      yes           yes               bound        192.168.1.100/24
```

---

## Exibir a tabela de rotas

```bash
ip route print
```

### Exemplo de Saída:
```bash
Flags: X - disabled, A - active, D - dynamic, C - connect, S - static, r - rip, b - bgp, o - ospf 
#      DST-ADDRESS        GATEWAY        DISTANCE
0 ADC  192.168.18.0/24    ether1         0
1 A S  0.0.0.0/0          192.168.18.1   1
```

---

## Criar NAT para compartilhamento de conexão
Este comando mascara todo o tráfego da rede local para sair pela interface WAN.

```bash
ip firewall nat add chain=srcnat action=masquerade out-interface=WAN
```

---

## Corrigir o NTP (Sincronização de Hora)
Manter o NTP (Network Time Protocol) atualizado evita problemas com logs e autenticação de dispositivos.

```bash
/system ntp client set enabled=yes primary-ntp=a.ntp.br secondary-ntp=b.ntp.br
```

---

## Configurar um link dedicado

### Criar um pool de IP
Adicione um endereço IP público na interface que receberá o link dedicado:

```bash
ip address add address=201.202.230.254/24 interface=ether2
```

### Configurar rota padrão
Defina o gateway padrão para acesso à internet:

```bash
ip route add dst-address=0.0.0.0/0 gateway=201.202.230.254
```

### Definir o DNS
Configure um servidor DNS público:

```bash
ip dns set servers=8.8.8.8
```

---

Este guia fornece comandos básicos para configuração e gerenciamento de redes no MikroTik via CLI.