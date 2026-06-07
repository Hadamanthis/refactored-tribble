# GDD — Loja de Poções Caótica

## 1. Visão geral

**Título provisório:** Loja de Poções Caótica
**Gênero:** casual / gerenciamento leve / arcade de pedidos
**Engine:** Godot 4.6
**Plataforma alvo:** PC e Web via itch.io
**Sessão de jogo:** 10 a 15 minutos
**Estrutura:** jogo em dias curtos, com clientes, receitas, dinheiro e eventos aleatórios.

## 2. Frase de venda

Administre uma pequena loja de poções onde clientes impacientes fazem pedidos, ingredientes se combinam de formas estranhas e eventos mágicos transformam cada dia em caos.

## 3. Objetivo do projeto

Criar um jogo casual pequeno, de uma tela principal, que sirva como projeto de aprendizado para:

* sinais/eventos;
* UI dinâmica;
* gerenciamento de estado;
* timers;
* cenas reutilizáveis;
* dados com Resources ou Dictionaries;
* sistema de receitas;
* eventos aleatórios;
* feedback visual e sonoro;
* ciclo completo de jogo com menu, gameplay, vitória e derrota.

O objetivo não é criar um simulador profundo. O objetivo é fazer um jogo pequeno, fechado, polido e publicável.

## 4. Fantasia do jogador

O jogador é um alquimista iniciante tentando sobreviver a uma semana administrando sua loja. Clientes chegam pedindo poções, mas a loja é instável: o caldeirão falha, ingredientes somem, clientes se irritam, promoções mágicas aparecem e pequenos problemas precisam ser resolvidos rapidamente.

A graça está em lidar com pedidos simples enquanto eventos atrapalham a rotina.

## 5. Pilares de design

### 5.1 Simplicidade

O jogador deve entender rapidamente:

1. cliente pede uma poção;
2. jogador escolhe ingredientes;
3. mistura no caldeirão;
4. entrega;
5. recebe dinheiro ou penalidade.

### 5.2 Caos controlado

Eventos aleatórios devem atrapalhar, mas não deixar o jogo injusto. O jogador precisa sentir que consegue reagir.

### 5.3 Uma tela, vários sistemas

O jogo deve acontecer quase todo em uma tela, mas com sistemas suficientes para ensinar Godot de forma prática.

### 5.4 Rejogabilidade leve

Mesmo com pouco conteúdo, os pedidos e eventos variam para cada partida parecer um pouco diferente.

## 6. Core loop

```text
cliente chega
→ pedido aparece
→ jogador escolhe ingredientes
→ mistura no caldeirão
→ entrega poção
→ recebe recompensa ou penalidade
→ próximo cliente chega
→ evento aleatório pode mudar a situação
```

## 7. Loop de longo prazo

```text
começar o dia
→ atender vários clientes
→ lidar com eventos
→ ganhar dinheiro
→ terminar o dia
→ desbloquear novo ingrediente/evento
→ avançar para o próximo dia
→ sobreviver até o fim da semana
```

## 8. Estrutura da partida

A campanha curta dura **7 dias**.

Cada dia dura entre **90 e 120 segundos**.

Ao final de cada dia:

* mostra resumo;
* dinheiro ganho;
* clientes atendidos;
* clientes perdidos;
* poções corretas;
* poções erradas;
* evento mais problemático do dia;
* desbloqueio simples para o próximo dia.

## 9. Condição de vitória

O jogador vence se chegar ao fim do Dia 7 com dinheiro positivo e reputação acima de zero.

## 10. Condição de derrota

O jogador perde se:

* dinheiro ficar abaixo de 0;
* reputação chegar a 0;
* muitos clientes forem embora insatisfeitos.

Para o MVP, escolha apenas uma condição principal:

**Recomendação:** derrota por reputação.

Exemplo:

* reputação inicial: 5 corações;
* cliente satisfeito: mantém ou aumenta reputação;
* cliente irritado: -1 reputação;
* poção errada: -1 reputação;
* reputação 0: fim de jogo.

## 11. Controles

### Mouse

* clicar em ingrediente para selecionar;
* clicar no caldeirão para adicionar;
* clicar em “misturar”;
* clicar no cliente para entregar;
* clicar em botões de UI.

### Teclado opcional

* tecla 1, 2, 3, 4 para ingredientes rápidos;
* Espaço para misturar;
* Enter para entregar.

Para o MVP, usar apenas mouse.

## 12. Tela principal

A tela principal deve ter:

```text
+------------------------------------------------+
| Dia 1     Tempo: 01:20      Dinheiro: 25       |
| Reputação: ♥ ♥ ♥ ♥ ♥                          |
+------------------------------------------------+
|                                                |
| Cliente atual                                 |
| "Quero uma poção de sono!"                    |
| Paciência: [========      ]                    |
|                                                |
| Ingredientes:                                  |
| [Lavanda] [Pimenta] [Gosma] [Cristal]          |
|                                                |
| Caldeirão:                                     |
| [Ingrediente 1] [Ingrediente 2] [Ingrediente 3]|
|                                                |
| [Misturar] [Entregar] [Limpar]                 |
|                                                |
| Evento atual: Nenhum                           |
+------------------------------------------------+
```

## 13. Sistema de clientes

Clientes são entidades simples com:

* nome;
* tipo visual;
* pedido;
* tempo de paciência;
* recompensa;
* penalidade;
* reação ao receber poção correta;
* reação ao receber poção errada.

### Exemplo de clientes

#### Camponês

* pedidos simples;
* paciência alta;
* paga pouco.

#### Cavaleiro

* pedidos de força, cura ou proteção;
* paciência média;
* paga bem.

#### Bruxa

* pedidos estranhos;
* paciência baixa;
* pode causar evento.

#### Aventureiro

* pedidos variados;
* recompensa média;
* chance de gorjeta.

#### Nobre

* pedidos exigentes;
* paga muito;
* penaliza muito se receber errado.

## 14. Sistema de pedidos

Cada pedido tem um efeito desejado.

Exemplos de efeitos:

* cura;
* sono;
* energia;
* força;
* proteção;
* velocidade;
* visão;
* veneno.

Para o MVP, usar apenas 5 efeitos:

1. cura;
2. sono;
3. energia;
4. força;
5. proteção.

## 15. Sistema de ingredientes

Cada ingrediente possui um ou mais efeitos.

### Ingredientes MVP

#### Lavanda

* efeito: sono

#### Pimenta

* efeito: energia

#### Cogumelo

* efeito: veneno

#### Cristal

* efeito: força

#### Gosma

* efeito: proteção

#### Erva Verde

* efeito: cura

#### Asa de Morcego

* efeito: velocidade

#### Água Mágica

* efeito: estabilizador

Para a primeira versão, use 6 ingredientes. Depois expanda para 8.

## 16. Sistema de receitas

O jogador combina ingredientes no caldeirão.

Cada poção pode usar de 1 a 3 ingredientes.

### Modelo simples

A poção resultante é definida pelo ingrediente principal.

Exemplo:

* Erva Verde → poção de cura
* Lavanda → poção de sono
* Pimenta → poção de energia
* Cristal → poção de força
* Gosma → poção de proteção

### Modelo recomendado para MVP

Usar receitas fixas simples:

```text
Erva Verde + Água Mágica = Cura
Lavanda + Água Mágica = Sono
Pimenta + Água Mágica = Energia
Cristal + Água Mágica = Força
Gosma + Água Mágica = Proteção
```

Isso ensina combinação sem ficar confuso.

### Modelo para versão 1.0

Adicionar modificadores:

```text
Água Mágica = estabiliza
Cristal = aumenta potência
Gosma = aumenta duração
Cogumelo = adiciona risco
```

Exemplo:

```text
Lavanda + Água Mágica = Poção de Sono
Lavanda + Gosma = Poção de Sono Longo
Lavanda + Cogumelo = Poção de Sono Instável
```

## 17. Caldeirão

O caldeirão é a área onde o jogador monta a poção.

### Regras

* suporta até 3 ingredientes;
* jogador pode limpar antes de misturar;
* ao clicar em “misturar”, o jogo calcula o resultado;
* depois de misturar, a poção fica pronta para entrega;
* ao entregar, o caldeirão esvazia.

### Estados do caldeirão

```text
vazio
recebendo ingredientes
pronto para misturar
poção pronta
entregue
limpo
```

## 18. Sistema de paciência

Cada cliente tem uma barra de paciência.

A paciência diminui com o tempo.

Se chegar a zero:

* cliente vai embora;
* jogador perde reputação;
* próximo cliente entra.

### Exemplo

```text
Camponês: 30 segundos
Cavaleiro: 25 segundos
Bruxa: 18 segundos
Nobre: 15 segundos
```

## 19. Sistema de dinheiro

O jogador ganha dinheiro por poções corretas.

Poções erradas podem:

* não dar dinheiro;
* reduzir reputação;
* gerar pequena penalidade.

### Recompensas sugeridas

```text
pedido simples: 5 moedas
pedido médio: 10 moedas
pedido difícil: 15 moedas
cliente nobre: 25 moedas
```

Para o MVP, dinheiro pode servir apenas como pontuação final. Não precisa de loja de upgrades no começo.

## 20. Sistema de reputação

Reputação representa quantos erros o jogador pode cometer.

### Regras

* começa com 5 corações;
* cliente satisfeito pode dar +1 coração se reputação estiver abaixo do máximo;
* cliente irritado remove 1 coração;
* poção errada remove 1 coração;
* reputação 0 encerra a partida.

## 21. Sistema de eventos aleatórios

Eventos são o principal diferencial e também o sistema mais importante para aprendizado.

Eventos podem começar durante o dia e durar alguns segundos.

### Regras

* apenas 1 evento ativo por vez no MVP;
* evento tem duração;
* evento mostra aviso visual;
* evento termina automaticamente;
* eventos ficam mais frequentes com o passar dos dias.

### Eventos MVP

#### 1. Cliente Apressado

O próximo cliente tem metade da paciência.

Aprendizado:

* modificar dados do próximo cliente;
* timer;
* evento temporário.

#### 2. Caldeirão Instável

Durante 20 segundos, poções erradas causam penalidade extra.

Aprendizado:

* estado global temporário;
* alteração de regra.

#### 3. Ingrediente Bloqueado

Um ingrediente fica indisponível por alguns segundos.

Aprendizado:

* UI bloqueada;
* evento afetando item específico.

#### 4. Promoção Mágica

Durante 20 segundos, poções corretas pagam o dobro.

Aprendizado:

* modificador de recompensa temporário.

#### 5. Rato Ladrão

Um rato aparece e tenta roubar um ingrediente. O jogador deve clicar nele antes que chegue ao ingrediente.

Aprendizado:

* instanciar cena temporária;
* movimento simples;
* clique em entidade;
* evento com sucesso/falha.

#### 6. Luz Apagada

A tela escurece parcialmente por alguns segundos.

Aprendizado:

* overlay visual;
* evento de atmosfera;
* feedback.

### Eventos para depois

* cliente misterioso;
* ingrediente falso;
* pedido mudando no meio do atendimento;
* caldeirão superaquecendo;
* chuva mágica reduzindo paciência;
* ingrediente bônus aparecendo.

## 22. Progressão por dia

### Dia 1

* tutorial implícito;
* 3 ingredientes;
* 2 tipos de pedido;
* sem eventos.

### Dia 2

* 4 ingredientes;
* 3 tipos de pedido;
* evento Cliente Apressado.

### Dia 3

* 5 ingredientes;
* 4 tipos de pedido;
* evento Ingrediente Bloqueado.

### Dia 4

* 6 ingredientes;
* 5 tipos de pedido;
* evento Promoção Mágica.

### Dia 5

* entra Rato Ladrão;
* clientes mais rápidos.

### Dia 6

* eventos mais frequentes;
* pedidos mais variados.

### Dia 7

* dia final;
* todos os sistemas ativos;
* maior velocidade de clientes;
* objetivo: sobreviver até o fim.

## 23. Dificuldade

A dificuldade aumenta por:

* menor paciência dos clientes;
* mais tipos de pedido;
* mais ingredientes disponíveis;
* eventos mais frequentes;
* maior penalidade por erro;
* mais clientes exigentes.

Evitar dificuldade por velocidade excessiva. O jogo deve ser caótico, mas legível.

## 24. Tutorial

Não criar tutorial longo.

Usar tutorial integrado no Dia 1.

### Primeira instrução

```text
Cliente: "Quero uma poção de cura!"
Dica: Clique em Erva Verde e depois no caldeirão.
```

### Segunda instrução

```text
Dica: Clique em Misturar para preparar a poção.
```

### Terceira instrução

```text
Dica: Clique em Entregar para servir o cliente.
```

Depois disso, o jogador aprende pelo uso.

## 25. Feedback visual

O jogo precisa dar respostas claras.

### Quando acerta

* cliente sorri;
* moeda sobe;
* som positivo;
* caldeirão brilha;
* texto “Perfeito!” aparece.

### Quando erra

* cliente fica irritado;
* som negativo;
* reputação pisca;
* texto “Poção errada!” aparece.

### Quando evento começa

* banner no topo;
* som de alerta;
* cor diferente na UI;
* pequeno texto explicativo.

### Quando evento termina

* texto “Evento encerrado”;
* UI volta ao normal.

## 26. Áudio

### Sons necessários

* clique em ingrediente;
* ingrediente caindo no caldeirão;
* mistura;
* poção pronta;
* entrega correta;
* entrega errada;
* cliente chegando;
* cliente indo embora;
* moedas;
* evento começando;
* evento terminando;
* derrota;
* vitória.

### Música

Uma música curta em loop, com clima leve e mágico.

## 27. Arte

### Direção visual

Visual 2D simples, colorido, com leitura clara.

### Estilo recomendado

* pixel art simples;
* ícones grandes;
* personagens com poucos frames;
* fundo estático;
* UI bem legível.

### Arte mínima

* fundo da loja;
* caldeirão;
* 6 a 8 ícones de ingredientes;
* 5 retratos de clientes;
* ícone de moeda;
* ícone de reputação;
* 1 rato;
* botões de UI;
* efeitos simples de brilho/fumaça.

## 28. UI principal

Elementos obrigatórios:

* tempo do dia;
* dinheiro;
* reputação;
* cliente atual;
* texto do pedido;
* barra de paciência;
* ingredientes;
* caldeirão;
* botão misturar;
* botão entregar;
* botão limpar;
* evento atual.

## 29. Telas

### Menu principal

* Jogar
* Como jogar
* Créditos
* Sair

### Tela de fim de dia

Mostrar:

* dia concluído;
* dinheiro ganho;
* clientes atendidos;
* erros;
* reputação restante;
* desbloqueio do próximo dia.

### Tela de vitória

Mostrar:

* dinheiro final;
* reputação final;
* total de clientes atendidos;
* avaliação final.

### Tela de derrota

Mostrar:

* dia alcançado;
* motivo da derrota;
* botão tentar novamente.

## 30. Estrutura técnica em Godot

### Cenas sugeridas

```text
Main.tscn
MainMenu.tscn
Game.tscn
HUD.tscn
Customer.tscn
IngredientButton.tscn
Cauldron.tscn
PotionResult.tscn
RandomEventBanner.tscn
RatEvent.tscn
EndDayScreen.tscn
GameOverScreen.tscn
VictoryScreen.tscn
```

### Scripts sugeridos

```text
game_manager.gd
day_manager.gd
customer_manager.gd
customer.gd
ingredient_button.gd
cauldron.gd
recipe_manager.gd
event_manager.gd
random_event.gd
money_manager.gd
reputation_manager.gd
hud.gd
audio_manager.gd
```

## 31. Arquitetura de sinais

Este jogo deve ser feito usando sinais para aprender eventos.

### Sinais importantes

```gdscript
signal day_started(day_number)
signal day_ended(day_number)

signal customer_spawned(customer)
signal customer_left(customer)
signal customer_satisfied(customer)
signal customer_angry(customer)

signal ingredient_selected(ingredient_id)
signal ingredient_added_to_cauldron(ingredient_id)
signal cauldron_cleared
signal potion_mixed(result_id)
signal potion_delivered(result_id)

signal money_changed(new_value)
signal reputation_changed(new_value)

signal random_event_started(event_id)
signal random_event_ended(event_id)

signal game_won
signal game_lost(reason)
```

## 32. Dados recomendados

### IngredientData

```text
id
nome
ícone
efeitos
disponível
```

### RecipeData

```text
id
nome
ingredientes_necessarios
efeito_resultante
valor_base
```

### CustomerData

```text
id
nome
sprite
paciência_base
tipo_de_pedido
recompensa_base
```

### RandomEventData

```text
id
nome
descrição
duração
peso_de_sorteio
dia_minimo
```

Para iniciante, pode começar usando Dictionaries. Depois migrar para Resources.

## 33. MVP obrigatório

O MVP só precisa ter:

* 1 tela de gameplay;
* 3 ingredientes;
* 3 receitas;
* 1 cliente por vez;
* barra de paciência;
* dinheiro;
* reputação;
* botão misturar;
* botão entregar;
* pedido certo/errado;
* 2 eventos aleatórios;
* tela de derrota;
* reiniciar partida.

Se isso funcionar, o jogo já tem base real.

## 34. Versão publicável na itch.io

Para postar com dignidade, mirar:

* 7 dias;
* 6 a 8 ingredientes;
* 8 a 10 receitas;
* 5 tipos de cliente;
* 6 eventos aleatórios;
* menu inicial;
* tela de como jogar;
* tela de vitória;
* tela de derrota;
* música;
* efeitos sonoros;
* feedback visual claro.

## 35. Stretch goals

Adicionar apenas depois da versão publicável.

* upgrades entre dias;
* receitas secretas;
* clientes especiais;
* finais diferentes;
* ranking local;
* modo infinito;
* ingredientes raros;
* sistema de livro de receitas;
* animação do caldeirão;
* conquistas internas.

## 36. O que não fazer no começo

Evitar:

* loja de upgrades complexa;
* inventário com estoque;
* muitos ingredientes;
* crafting profundo;
* mapa da cidade;
* diálogo longo;
* sistema de reputação por facção;
* clientes com histórias longas;
* economia complexa;
* dias muito longos;
* minigames demais.

Essas coisas podem transformar um jogo simples em um projeto grande demais.

## 37. Cronograma sugerido

### Etapa 1 — Protótipo de receita

Objetivo: provar o loop básico.

Entregas:

* ingredientes clicáveis;
* caldeirão recebe ingredientes;
* botão misturar;
* receita correta ou errada;
* texto mostrando resultado.

### Etapa 2 — Cliente e pedido

Objetivo: transformar receita em jogo.

Entregas:

* cliente aparece;
* pedido é exibido;
* jogador entrega poção;
* cliente reage;
* dinheiro muda;
* próximo cliente aparece.

### Etapa 3 — Tempo e derrota

Objetivo: criar pressão.

Entregas:

* barra de paciência;
* cliente vai embora;
* reputação;
* derrota por reputação 0.

### Etapa 4 — Eventos aleatórios

Objetivo: aprender eventos e deixar o jogo interessante.

Entregas:

* EventManager;
* 2 eventos simples;
* banner de evento;
* duração de evento;
* evento afetando regra do jogo.

### Etapa 5 — Progressão por dias

Objetivo: fechar estrutura de partida.

Entregas:

* Dia 1 a Dia 7;
* tela de fim de dia;
* novos ingredientes;
* novos eventos;
* vitória no fim.

### Etapa 6 — Polimento

Objetivo: deixar publicável.

Entregas:

* menu;
* sons;
* música;
* animações simples;
* partículas;
* ícones;
* tela de como jogar;
* export para itch.io.

## 38. Critério de sucesso

O jogo está funcionando bem se:

* o jogador entende em menos de 1 minuto;
* errar uma poção não parece injusto;
* eventos deixam o jogo mais divertido, não irritante;
* cada dia parece um pouco mais difícil;
* uma partida completa dura menos de 15 minutos;
* reiniciar é rápido;
* o jogador quer tentar “só mais um dia”.

## 39. Primeira meta real

Antes de pensar em arte, faça uma cena cinza com botões simples:

* 3 botões de ingredientes;
* 1 caldeirão;
* 1 pedido escrito;
* 1 botão misturar;
* 1 botão entregar;
* dinheiro;
* reputação.

Se isso já parecer minimamente divertido, o projeto vale continuar.

## 40. Resumo do escopo recomendado

A versão ideal para você terminar:

```text
1 tela principal
7 dias
6 ingredientes
8 receitas
5 clientes
6 eventos
dinheiro
reputação
timer
menu
vitória/derrota
```

Esse escopo ensina Godot sem exigir toneladas de conteúdo.
