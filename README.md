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


# connect to romon
Este comando ativa o romon com sua respectiva senha
```bash
tool/romon/set enabled=yes secrets=88191198
```

## Criar usuarios

Para criar um usuario no microtick fica em 

```bash
/user add name=usuario password=senha group=full

```

## Alterar a porta de serviços

Listar portas de serviços

```bash
ip service print
```
```bash
[admin@MikroTik  Provedor] > ip service print 
Flags: X, I - INVALID
Columns: NAME, PORT, CERTIFICATE, VRF
#   NAME     PORT  CERTIFICATE  VRF 
0 X telnet     23               main
1 X ftp        21                   
2   www        80               main
3   ssh        22               main
4 X www-ssl   443  none         main
5 X api      8728               main
6   winbox   8597               main
7 X api-ssl  8729  none         main
[admin@MikroTik  Provedor] > 
```

Para alterar a porta do serviço
```bash
/ip service set winbox port=<nova_porta>

```

Para desabilitar a porta de um serviço

```bash
 ip service disable <nome da porta>
```

## Alterar Identificação do roteador
Mudar o nome do roteador Microtick

```bash
/system/indentfy set name=<Nome do roteador>
```


## Backup
Dentro do Microtick deve se sempre subir o backup no mesmo tipo de equipamento

### Tipos de backup

    - .bkp: Clona MAC das interfaces, usuarios e senhas de ROS
    - RSC: Compativel com Harddware diferentes, pode fazer backup e restore por partes do conteudo.

Comando para gerar um bkp
```bash
system/backup save  name=<Nome do Backup>
```


Gerando um backup somente do firewall 
```bash
ip firewall/export file=teste123 
```

Adicionando o comando terse, quando se abre o backup você consegue ver linha por linha a configuração do equipamento.

```bash
ip firewall/export file=teste123 terse
```

Exemplo de backup terse

```bash
# feb/04/2025 01:09:07 by RouterOS 7.2.3
# software id = 
#
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
/user group
add name=SuporteN1 policy="local,read,winbox,password,!telnet,!ssh,!ftp,!reboo\
    t,!write,!policy,!test,!web,!sniff,!sensitive,!api,!romon,!dude,!rest-api"
/ip address
add address=199.1.1.1/24 interface=ether2 network=199.1.1.0
/ip dhcp-client
add interface=ether1
/ip dns
set servers=8.8.8.8
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add gateway=192.168.88.1
/ip service
set telnet disabled=yes
set ftp disabled=yes
set api disabled=yes
set winbox port=8597
set api-ssl disabled=yes
/system identity
set name="MikroTik  Provedor"
/tool romon
set enabled=yes

```

Como executar o c
```bash
export file=tudo
```


# Botão de Reset
Botão de reset tem 4 funções adicionadas da seguinte forma

    - Desligar a fonte da RB
    - Ligar a RB com o reset precionado
    - Solte o botão reset no tempo X
        - 3 Seg ativa o backup da RouterBOOT
        - 5 seg resert do equipamento
        - 10 seg ativa o modo CAPS(A parte de WI-FI irá ser administrada por outro equipamento na rede )
        - 15 seg ou mais reinstalação via Netinstall




# DHCP Client
Quando o algum dispositivo chega e começa a procurar por IPs ele faz o processo que chamaos de DORA
DORA.

D = Discover - Dispositivo fazendo descoberta de rede no loca
O = Offer - Oferta do servidor DHCP para o cliente
R = Request - Solicitação de aceitação do servidor DHCP
A = Ack - COnfirmação do DHCP que foi entregue o Ip


Quando ele faz a descoberta de rede, o dispositivo ele procura servidores DHCP na rede multicast e o servidor DHCP sempre responde na unicast.

Colocar o codigo de criação do DHCP


# Bridge

- Bridge é um dispositivo de camada 2 osi
- São dispositvos transparentes
- Um switch de rede é uma bridge com multiplas portas
- Ao criar uma Brifge ela usa o mac address da porta selecionada


## Hardware offload

Quando se cria uma bridge ele ja traz a teclonogia de hardware offload para poder trafegar dados somente nas portas do switch, agora quando se tem uma interface normal
o trafego de dados se passa dentro dentro do switch chip que gerencia as portas até a CPU para decisões de roteamento.

Para se criar um bridge

```bash
/interface bridge add name=bridge1
```

Para acossiar as interfaces a bridge
```bash
interface/bridge/port/add bridge=bridge-Lan interface=ehter
```


# Roteamento

Flags

    -   D - dynamic
    -   X - disabled
    -   I - inactive
    -   A - active
    -   c - connect
    -   s - static
    -   r - rip
    -   b - bgp
    -   o - ospf
    -   d - dhcp
    -   v - vpn
    -   m - modem
    -   y - copy
    -   H - hw-offloaded 
    -   ecmp - Equal-Cost Multi-Path

ip > routes

Na tabela de roteamento temos alguns campos como 

    - dst address (Aonde quer chegar ? )
    - gateway (De onde quer sair ? )


## Check gateway
A cada 10 segundos envia um ICMP echo request(ping) ou uma Solicitação arp request
Se varias rotas usam o mesmo gateway e existe uma rota que tem opção Check gateay habilitada, então todas as rotas estão sujeitas ao comportamento do gateway, se ele estiver down as rotas não são direcioondas.

o campo distace dentro do ip route é quem define por onde vai passar o trafego.


Entregar o 201.202.230.254 na operadora 2 do tipo cloud3

### Exemplo pratico
[lab](/Microtick/img/LAB.jpeg)
Digamos que queremos que o computador da filia consiga reconhecer a os computadores do estoque e vice versa.

Podemos criar uma rota que tudo quando for para 192.168.20.0/24 ele irá sair pelo gateway do estoque 10.10.1.2/30 e o contrario tambem a ser feito, tudo que for com destino a 192.168.40.0/24 irá sair pelo gateway 10.10.1.1/30.

Sendo assim acessamos o roteador microtik da fila e fazemos o seguite comando

```bash
ip/route/add dst-address=192.168.20.0./24 gateway=10.10.1.2
```

Depois acessarmos o roteador do estoque do estoque e fazer o mesmo para o outro lado.

```bash
ip/route/add dst-address=192.168.40.0./24 gateway=10.10.1.1
```
Sendo assim nossos computadores das duas redes locais consguem se conectar, um unico ponto de lembrança é que para os computadores do estoque sairem para rede, não se deve ter nenhuma config de nateamento, criando somente uma rota default apontando que caso irão sair para rede vão sair pelo gateway da filia.

```bash
ip/route add gateway=10.10.1.1/30
```
Quando não apontamos o dst-address via cli ele automaticamente detecta que faz parte de uma rota default e que o destino é 0.0.0.0/0 que será a internet.


# Wireless

Microtick router os prevê suporte completo aos padrões de rede wireless IEEE
    - 802.11a/n/ac(5Ghz)
    - 802.11b/g/n(2.4Ghz
    - 802.11ad/(60Ghz) Wireless WIre

## NV2

    - É um protocolo Wireles propietario da Microtick
    - Beneficios
        - Maior Velocidade
        - Baixa Latência
    - TDMA - TIma DIvision MUltiple Access
    - O NV2 não aceita Birtual AP e o limite é de 511

| **Padrão IEEE** | **Frequência** | **Velocidade**        |
|----------------|--------------|----------------------|
| 802.11a       | 5GHz         | 54Mbps              |
| 802.11b       | 2.4GHz       | 11Mbps              |
| 802.11g       | 2.4GHz       | 54Mbps              |
| 802.11n       | 2.4 e 5GHz   | Até 450 Mbps*       |
| 802.11ac      | 5GHz         | Até 1300 Mbps*      |
| 802.11ad      | 60GHz        | 2 Gbps              |

*Depende do modelo RB


![alt text](image.png)

Atualmente pode se ultilizar 3 Aps microtick na mesma rede sem sofrer interferencia de sinal

Para ativar de certa maneira o "mesh" colocar os aps com mesmo ssid e senha que ja irá fazer o roming normalmente.

Pontos importantes:
    - Quanto maior a largura do canal
        - Menor numero de numero de canais
        - Mais vulneravel a interferências
        - Diminuiu a a potencia do sinal a logas distancias
    

## Modes Wifi
| Modo            | Se conecta a um AP | Atua como AP | Passa múltiplos MACs? | Uso comum                     |
|---------------|----------------|-----------|----------------|-----------------------------|
| **Station Bridge** | ✅ Sim | ❌ Não | ✅ Sim | Cliente Wi-Fi transparente |
| **AP Bridge** | ❌ Não | ✅ Sim | ✅ Sim | Roteador principal Wi-Fi |
| **Bridge** | ✅ Sim (somente 1 AP) | ❌ Não | ❌ Não | Links PTP |
| **Station** | ✅ Sim | ❌ Não | ❌ Não | Cliente Wi-Fi com NAT |









# firewall

## Stateless

firewall stateles normalmente tende a somente verificar o cabeçalho da requisição e deixar passar, ele não grava em si se aquele pacote ou conexão 
ja pertence ou esta ativa. Apenas se é analisado o cabeçalho do pacote e ip de destino e se aplica a configurações predefinidas do administrador da rede.

    Vantagens
        - Mais rapido pois não precisa manter tabelas de conexão
        - Menos consumo de memoria e CPU
        - Util para cenarios de alto desempenho como load balances.

    Desvantagens
        - Menos seguro, pois não consegue detectar ataques que exploram conexões estabelecidas
        - Pode permitir trafego não autorizado por não reconhecer conexões estabelecidas.

## Statefull

Em contrapartida o statefull  mantem o rastreamento das conexões ativas da rede. Isso significa que ele analisa não apenas pacotes individualmente, mas tambem
a relação dos pacotes com as conexões ja estabelecidas. Ele verifica se o pacote faz parte de uma conexão existente ou se esta tentando estabelecer uma nova conexão
assim ele consegue permitr ou bloquear pacotes com base no estado da conexão.

    Vantagens
    -   Maior segurança, pois verifca se o trafego são de conexões legitimas
    -   Redução de trafego desencesário, ja que não precisa reavaliar pacotes conhecidos
    -   Permite criar regras mais sofisticadas, como permitir apenas conexões iniciadas de dentro da rede.

    Desvantagens
    -   Consome mais recurso (Memoria e processamento) por armazenar estados das conexões



## Filter rules

Filter rules é onde criamos nossa regras de firewall para permitir ou bloquear trafego em nossa rede com base em diversos criterios como IP, Porta, protocolo e lan
Exemplos: 
    - BLoquear sites: Criar regra para impedir acesso a domínios especificos
    - Liberar ou bloquear Portas: Definir quais portas podem ser acessadas de dentro da rede.
    - Proteção LAN: Bloquear acessos indesejados na rede local 
    - segurança do seu router: Impedir ataques como Brute Force, DDoS e proteger serviços administrativos como SSH e winbox

Exemplo de comando:
```bash
/ip firewall filter add chain=forward action=drop dst-port=22 protocol=tcp
```
Aqui estamos bloqueando o trafego na porta SSH(22)

## NAT(Network address translation)

O Nat é onde podemos modificar os endereços e portas dos pacotes que entram e saem da rede.

`Tipos prncipais de NAT`:
    -   `Masquerade`: Usado mascarar um IP local para um IP publico
    -   `Dst-NAT(Destination NAT)`: Redireciona pacotes para um IP e porta especificos
            - Exemplo:
                Direcionar trafego da porta 80 para um servidor WEB
        
    -   `Src-NAT(Source NAT)`: Altera o ip de origem dos  pacotes

Exemplo de comando ultilizando src-nat e Masquerade:
```bash
/ip firewall nat add chain=srcnat action=masquerade out-interface=ether1
```
Tudo que vier da minha rede local, saem pela interface ether 1 para que todos compartilhem o mesmo IP publico


## Mangle
O Mangle permite manipular pacotes para controle de trafego avançado, marcação de conexões e implementação de balanceamento de carga.
Pricipais usos:
    -   `Load Balances`: Distribuir tráfego entre multiplos links de internet.
    -   `Marcaçoes de pacotes e conexões`: Para aplicar regras especificas baseado no trafego
    -   `Alterações de pacotes TTL(Time to live)`: Impedir que provedores detectem roteamento de internet compartilhado

Exemplo de marcação de pacote para load balance:

```bash
/ip firewall mangle add chain=prerouting action=mark-connection new-connection-mark=WAN1_conn passthrough=yes in-interface=WAN1
```
Aqui, estamos marcando conexões que entram pela interface WAN1



## Raw
firewall que age diretamente na interface WAN do microtick antes mesmo de passar pelas regras de Filter, NAT e mangle, ele pode descartar pacotes antes que sejam 
analisados pelo restante do firewall.

Principais usos: 
    -   Descartar pacotes antes que chegue no firewall do Microtick, evitando aumento do processamento do equipamento
    -   Proteção contra ataques DDoS e scans de rede, podendo descartar pacotes maliciosos como SYN fload, Port Scanners e outros ataques comums.
    
Exemplos de comandos: 

    1. Bloqueio de pacotes de ataques DDoS
    ```bash
    /ip firewall raw add chain=prerouting protocol=tcp tcp-flags=syn action=drop
    ```
    2. Bloqueia uma lista de ips suspeitos realizando scans de porta
    ```bash
    /ip firewall raw add chain=prerouting src-address-list action=drop
    ```


### Tipos de chain
![chain](/Microtick/img/chains.png)

Dentro do conceito de firewall temos três tipos padrões  de fluxos de pacotes.
    - `Input`: Destinado ao router
    - `Foward`: Passando pelo router
    - `Output`: A partir do router

#### Input

![Chain input](/Microtick/img/chain-input.png)

Tudo que se chega ao seu router, seja da internet ou rede local se considera como LAN

#### Foward
![chain forward](image.png)
Todo trafego que passe pelo nosso Microtick.
Exemplo, computador da minha rede local quer se comunicar com a impressora, o dst-addres que o computador manda a requisição é diretamente o IP da minha impressora, porem obrigatoriamente ele tende a passar pelo gateway, isso seria um trafego do tipo foward.


#### Output
Seria todo trafego inicializado a partir de meu router.
