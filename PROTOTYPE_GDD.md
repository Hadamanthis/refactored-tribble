# GDD — Protótipo: Loja de Poções

## 1. Objetivo do protótipo

Criar uma primeira versão jogável extremamente simples da mecânica principal da loja de poções.

O protótipo deve provar apenas este loop:

```text
cliente pede uma poção
→ jogador escolhe ingredientes
→ mistura no caldeirão
→ entrega ao cliente
→ jogo informa se acertou ou errou
```

Este protótipo não precisa ter arte final, música, eventos aleatórios, progressão por dias, upgrades, múltiplos clientes ou menus completos.

O objetivo é validar se a base do jogo funciona em Godot 4.6.

---

## 2. Escopo do protótipo

### Inclui

* uma tela de jogo;
* um cliente fixo;
* um pedido fixo;
* três ingredientes;
* um caldeirão;
* botão de misturar;
* botão de entregar;
* resultado certo ou errado;
* feedback visual simples;
* botão de reiniciar.

### Não inclui

* sistema de dias;
* eventos aleatórios;
* múltiplos clientes;
* dinheiro;
* reputação;
* barra de paciência;
* loja de upgrades;
* animações complexas;
* inventário;
* save;
* sons;
* música;
* tutorial completo.

---

## 3. Conceito

O jogador é um alquimista iniciante atendendo um cliente.

O cliente pede uma poção específica. O jogador deve selecionar os ingredientes corretos, colocá-los no caldeirão, misturar e entregar a poção.

Se a combinação estiver correta, o cliente fica satisfeito.
Se estiver errada, o cliente reclama.

---

## 4. Core loop do protótipo

```text
ler pedido do cliente
→ clicar nos ingredientes
→ ingredientes entram no caldeirão
→ clicar em Misturar
→ clicar em Entregar
→ receber resultado
→ reiniciar
```

---

## 5. Tela principal

A tela pode ser simples, feita com UI básica da Godot.

Estrutura sugerida:

```text
+------------------------------------------------+
| Cliente                                        |
|                                                |
| "Quero uma poção de cura!"                     |
|                                                |
| Ingredientes                                   |
| [Erva Verde] [Lavanda] [Pimenta]               |
|                                                |
| Caldeirão                                      |
| Ingredientes adicionados: Erva Verde, Água     |
|                                                |
| [Misturar] [Entregar] [Limpar]                 |
|                                                |
| Resultado:                                    |
|                                                |
| [Reiniciar]                                    |
+------------------------------------------------+
```

Para o protótipo, o cliente pode ser apenas um painel com texto. Não precisa ter sprite.

---

## 6. Ingredientes do protótipo

O protótipo terá 3 ingredientes.

### 6.1 Erva Verde

Função: ingrediente correto para poção de cura.

### 6.2 Lavanda

Função: ingrediente incorreto para este pedido.

### 6.3 Pimenta

Função: ingrediente incorreto para este pedido.

---

## 7. Pedido do cliente

O pedido será fixo:

```text
"Quero uma poção de cura!"
```

A receita correta será:

```text
Erva Verde
```

Para simplificar, o protótipo não precisa exigir dois ingredientes. Uma única escolha correta já prova a base do sistema.

---

## 8. Regras do caldeirão

O caldeirão guarda os ingredientes escolhidos pelo jogador.

### Regras

* o jogador pode adicionar até 2 ingredientes;
* ingredientes clicados aparecem na área do caldeirão;
* o jogador pode clicar em “Limpar” para esvaziar o caldeirão;
* o botão “Misturar” transforma os ingredientes em uma poção;
* depois de misturar, o jogador pode entregar a poção.

---

## 9. Estados do caldeirão

O caldeirão deve ter quatro estados:

```text
vazio
recebendo ingredientes
poção misturada
poção entregue
```

### 9.1 Vazio

Nenhum ingrediente foi adicionado.

### 9.2 Recebendo ingredientes

O jogador já adicionou pelo menos um ingrediente.

### 9.3 Poção misturada

O jogador clicou em “Misturar”. A poção está pronta para entrega.

### 9.4 Poção entregue

O jogador clicou em “Entregar”. O jogo mostra o resultado.

---

## 10. Regras de vitória e erro

### Poção correta

Se a poção contém Erva Verde, o resultado é correto.

Mensagem:

```text
"Poção correta! O cliente ficou feliz."
```

### Poção errada

Se a poção não contém Erva Verde, o resultado é errado.

Mensagem:

```text
"Poção errada! O cliente ficou irritado."
```

### Entregar sem misturar

Se o jogador clicar em entregar antes de misturar:

```text
"Misture a poção antes de entregar."
```

### Misturar caldeirão vazio

Se o jogador clicar em misturar sem ingredientes:

```text
"Adicione um ingrediente primeiro."
```

---

## 11. Interações do jogador

### Clicar em ingrediente

Ao clicar em um ingrediente:

* o ingrediente é adicionado ao caldeirão;
* o nome do ingrediente aparece na lista do caldeirão.

### Clicar em Limpar

Ao clicar em “Limpar”:

* o caldeirão fica vazio;
* a lista de ingredientes é apagada;
* o estado volta para vazio.

### Clicar em Misturar

Ao clicar em “Misturar”:

* se houver ingrediente, o caldeirão muda para “poção misturada”;
* se não houver ingrediente, aparece mensagem de aviso.

### Clicar em Entregar

Ao clicar em “Entregar”:

* se a poção foi misturada, o jogo verifica se está correta;
* se a poção não foi misturada, aparece mensagem de aviso.

### Clicar em Reiniciar

Ao clicar em “Reiniciar”:

* o pedido volta ao início;
* o caldeirão fica vazio;
* o resultado some;
* o jogador pode tentar de novo.

---

## 12. Feedback visual

Mesmo sem arte final, o protótipo deve ter feedback claro.

### Quando adiciona ingrediente

Mostrar texto:

```text
"Erva Verde adicionada ao caldeirão."
```

### Quando mistura

Mostrar texto:

```text
"A poção foi misturada."
```

### Quando acerta

Mudar o painel de resultado para uma cor positiva, como verde.

### Quando erra

Mudar o painel de resultado para uma cor negativa, como vermelho.

### Quando ação é inválida

Mostrar aviso em texto.

---

## 13. Estrutura de cenas em Godot

Para o protótipo, usar poucas cenas.

```text
PrototypeGame.tscn
IngredientButton.tscn
Cauldron.tscn
```

Também é aceitável fazer tudo em uma única cena no começo, mas separar o botão de ingrediente já ajuda no aprendizado.

---

## 14. Nós sugeridos em PrototypeGame.tscn

```text
PrototypeGame
├── UI
│   ├── CustomerPanel
│   │   └── OrderLabel
│   ├── IngredientsPanel
│   │   ├── HerbButton
│   │   ├── LavenderButton
│   │   └── PepperButton
│   ├── CauldronPanel
│   │   └── CauldronIngredientsLabel
│   ├── ActionsPanel
│   │   ├── MixButton
│   │   ├── DeliverButton
│   │   ├── ClearButton
│   │   └── RestartButton
│   └── ResultPanel
│       └── ResultLabel
```

---

## 15. Scripts sugeridos

### prototype_game.gd

Responsável por controlar o fluxo principal do protótipo.

Guarda:

```text
pedido_atual
ingredientes_no_caldeirao
pocao_misturada
pocao_entregue
```

Funções principais:

```text
adicionar_ingrediente(ingrediente_id)
misturar_pocao()
entregar_pocao()
limpar_caldeirao()
reiniciar()
verificar_receita()
atualizar_ui()
```

---

## 16. Dados mínimos

Ingredientes podem ser representados por strings no protótipo.

```gdscript
const INGREDIENT_HERB = "erva_verde"
const INGREDIENT_LAVENDER = "lavanda"
const INGREDIENT_PEPPER = "pimenta"
```

A receita correta pode ser:

```gdscript
var receita_correta = ["erva_verde"]
```

O caldeirão pode guardar:

```gdscript
var ingredientes_no_caldeirao: Array[String] = []
```

---

## 17. Sinais a aprender no protótipo

Este protótipo deve começar a ensinar sinais.

### Sinal de ingrediente selecionado

Cada botão de ingrediente pode emitir:

```gdscript
signal ingredient_selected(ingredient_id)
```

Quando o jogador clica no botão, ele emite o sinal para a cena principal.

Exemplo conceitual:

```text
IngredientButton
→ emite ingredient_selected
→ PrototypeGame recebe
→ adiciona ingrediente ao caldeirão
```

Esse é o primeiro aprendizado importante de eventos.

---

## 18. Fluxo completo esperado

### Início

O jogo mostra:

```text
Cliente: "Quero uma poção de cura!"
Caldeirão vazio.
Resultado vazio.
```

### Jogador clica em Erva Verde

O caldeirão mostra:

```text
Erva Verde
```

### Jogador clica em Misturar

O resultado temporário mostra:

```text
"A poção foi misturada."
```

### Jogador clica em Entregar

O resultado final mostra:

```text
"Poção correta! O cliente ficou feliz."
```

### Jogador clica em Reiniciar

Tudo volta ao estado inicial.

---

## 19. Critério de conclusão do protótipo

O protótipo está concluído quando:

* o pedido aparece na tela;
* o jogador consegue clicar nos ingredientes;
* os ingredientes aparecem no caldeirão;
* o jogador consegue limpar o caldeirão;
* o jogador consegue misturar;
* o jogador consegue entregar;
* o jogo reconhece poção correta;
* o jogo reconhece poção errada;
* o jogo impede entregar sem misturar;
* o botão reiniciar funciona;
* pelo menos um sinal é usado para comunicar o clique do ingrediente à cena principal.

---

## 20. Próximos passos depois do protótipo

Somente depois deste protótipo funcionar, adicionar:

1. segundo pedido;
2. segunda receita;
3. cliente com paciência;
4. dinheiro;
5. reputação;
6. evento aleatório simples.

Não adicionar esses sistemas antes do loop básico estar funcionando.
