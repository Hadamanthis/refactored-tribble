# Sprints - Boticario Iniciante

Este plano transforma o GDD em etapas pequenas de aprendizado e validacao. O objetivo nao e correr para adicionar sistemas, mas provar o loop central com clareza: cliente pede, jogador escolhe ingrediente, mistura, entrega e recebe feedback.

Versao alvo: Godot 4.6.

Politica de versao: antes de cada sprint tecnica, verificar a documentacao estavel da Godot e as notas da versao mais recente. Se houver uma pratica melhor em versoes novas, ela deve ser discutida antes de mudar o projeto. A versao do projeto so muda com decisao explicita.

Fontes de referencia:

- Godot 4.6 docs: https://docs.godotengine.org/en/4.6/
- Godot best practices: https://docs.godotengine.org/en/4.6/tutorials/best_practices/index.html
- Godot 4.6 release notes: https://godotengine.org/releases/4.6/

## Principios do projeto

- Primeiro fazer o loop jogavel, depois expandir.
- Usar cenas pequenas quando isso ensinar composicao.
- Usar sinais para comunicacao de eventos do jogador.
- Manter estado explicito para evitar bugs invisiveis.
- Evitar singletons/autoloads ate existir uma necessidade real.
- Preferir nomes claros a abstracoes prematuras.
- Separar, quando possivel, regra de jogo de atualizacao visual.
- Toda sprint termina com um teste manual jogavel.

## Sprint 0 - Preparacao e contrato de aprendizado

Status: Concluida.

Objetivo: deixar claro como o projeto sera conduzido e quais limites existem.

Entregas:

- Confirmar que o projeto abre na Godot 4.6.
- Confirmar que o escopo do GDD e o prototipo de loja de pocoes.
- Confirmar que o assistente atua como professor e nao altera codigo diretamente.
- Definir que o primeiro alvo e apenas uma tela jogavel.

Conceitos ensinados:

- Escopo minimo viavel.
- Diferenca entre GDD, plano de sprint e implementacao.
- Como evitar crescimento descontrolado de features.

Checklist:

- [x] Projeto abre sem erros na Godot 4.6.
- [x] GDD revisado.
- [x] Escopo do prototipo aceito.
- [x] Nenhum sistema fora do GDD foi adicionado.

Definition of Done:

- Voce consegue explicar em uma frase qual loop esta sendo testado.

## Sprint 1 - Cena principal e layout jogavel

Status: Concluida.

Objetivo: criar a tela principal com todos os elementos visiveis, ainda sem regras completas.

Entregas:

- Cena `PrototypeGame.tscn`.
- Painel do cliente com o pedido fixo.
- Area de ingredientes com tres botoes.
- Area do caldeirao com lista de ingredientes.
- Area de acoes com botoes: Misturar, Entregar, Limpar, Reiniciar.
- Area de resultado.

Arvore sugerida com tipos:

```text
PrototypeGame (Control)
└── MainMargin (MarginContainer)
    └── MainLayout (VBoxContainer)
        ├── CustomerPanel (PanelContainer)
        │   └── CustomerLayout (VBoxContainer)
        │       ├── CustomerTitleLabel (Label)
        │       └── OrderLabel (Label)
        ├── IngredientsPanel (PanelContainer)
        │   └── IngredientsLayout (VBoxContainer)
        │       ├── IngredientsTitleLabel (Label)
        │       └── IngredientButtonsRow (HBoxContainer)
        │           ├── HerbButton (Button)
        │           ├── LavenderButton (Button)
        │           └── PepperButton (Button)
        ├── CauldronPanel (PanelContainer)
        │   └── CauldronLayout (VBoxContainer)
        │       ├── CauldronTitleLabel (Label)
        │       └── CauldronIngredientsLabel (Label)
        ├── ActionsPanel (PanelContainer)
        │   └── ActionsRow (HBoxContainer)
        │       ├── MixButton (Button)
        │       ├── DeliverButton (Button)
        │       ├── ClearButton (Button)
        │       └── RestartButton (Button)
        └── ResultPanel (PanelContainer)
            └── ResultLabel (Label)
```

Se a cena ja foi criada como `Game (Node2D)`, isso funciona para comecar, mas para uma tela 100% UI a opcao mais profissional nesta sprint e usar `Control` como raiz. `Node2D` faz mais sentido quando a raiz representa um mundo 2D com posicoes, sprites, cameras e fisica.

Conceitos ensinados:

- Arvore de nos.
- Cenas como unidades de composicao.
- Uso de `Control`, `PanelContainer`, `VBoxContainer`, `HBoxContainer`, `Button` e `Label`.
- Separacao entre estrutura visual e regra de jogo.

Boas praticas:

- Nomear nos pelo papel no jogo, nao pela aparencia.
- Usar containers para layout em vez de posicionamento manual.
- Manter a cena legivel antes de adicionar script.
- Evitar efeitos visuais antes do fluxo funcionar.

Checklist:

- [x] Todos os elementos do GDD aparecem na tela.
- [x] A tela se adapta minimamente ao tamanho da janela.
- [x] Os botoes existem, mesmo que ainda nao facam tudo.
- [x] O pedido fixo aparece claramente.

Teste manual:

- Abrir a cena e verificar se o jogador entende onde esta cliente, ingredientes, caldeirao, acoes e resultado.

Definition of Done:

- A tela comunica o fluxo do jogo sem precisar de explicacao externa.

## Sprint 2 - Ingredientes e sinais

Status: Concluida.

Objetivo: fazer os botoes de ingrediente comunicarem a escolha para a cena principal usando sinais.

Entregas:

- Cena opcional `IngredientButton.tscn`, se a repeticao ja justificar.
- Sinal conceitual `ingredient_selected(ingredient_id)`.
- Clique em ingrediente adiciona o ingrediente ao caldeirao.
- Lista visual do caldeirao atualiza apos cada clique.

Conceitos ensinados:

- Observer pattern por meio de sinais.
- Baixo acoplamento entre botao e cena principal.
- Parametros em sinais.
- Quando criar cena reutilizavel e quando manter simples.

Boas praticas:

- O botao de ingrediente nao deve conhecer a regra da receita.
- O botao apenas informa "fui escolhido".
- A cena principal decide o que fazer com a escolha.
- Evitar `get_parent()` como dependencia principal.

Checklist:

- [x] Cada ingrediente envia um identificador claro.
- [x] O caldeirao mostra os ingredientes clicados.
- [x] O limite de ate 2 ingredientes e respeitado ou planejado claramente.
- [x] Pelo menos um sinal e usado no fluxo.

Teste manual:

- Clicar em Erva Verde, Lavanda e Pimenta e conferir se os nomes aparecem no caldeirao.

Definition of Done:

- Voce consegue explicar quem emite o sinal, quem escuta e por que isso reduz acoplamento.

## Sprint 3 - Estado do caldeirao

Status: Concluida.

Objetivo: implementar os quatro estados do caldeirao definidos no GDD.

Estados:

- `vazio`
- `recebendo_ingredientes`
- `pocao_misturada`
- `pocao_entregue`

Entregas:

- Estado atual do caldeirao armazenado de forma explicita.
- Acao Limpar volta para `vazio`.
- Acao Misturar muda para `pocao_misturada` quando valida.
- Acao Entregar muda para `pocao_entregue` quando valida.
- Acoes invalidas mostram feedback.

Conceitos ensinados:

- State pattern em versao simples.
- Guard clauses para impedir acoes invalidas.
- Transicoes de estado.
- Como reduzir flags soltas demais.

Boas praticas:

- Uma acao deve validar pre-condicoes antes de alterar estado.
- Estados devem ter nomes que expressem regra de jogo.
- Evitar booleanos demais quando um enum ou estado nomeado explica melhor.
- Cada transicao deve atualizar a UI de forma previsivel.

Checklist:

- [x] Misturar caldeirao vazio mostra aviso.
- [x] Entregar antes de misturar mostra aviso.
- [x] Limpar reseta ingredientes e estado.
- [ ] Reiniciar reseta o fluxo inteiro.

Teste manual:

- Tentar misturar vazio.
- Tentar entregar sem misturar.
- Adicionar ingrediente, limpar e confirmar que tudo volta ao inicio.

Definition of Done:

- Nao existe caminho de clique que deixe a UI em contradicao com o estado interno.

## Sprint 4 - Receita, validacao e resultado

Status: Concluida.

Objetivo: verificar se a pocao entregue atende ao pedido fixo.

Entregas:

- Receita correta: `erva_verde`.
- Entrega correta mostra mensagem positiva.
- Entrega errada mostra mensagem negativa.
- Painel de resultado muda visualmente conforme sucesso ou erro.

Conceitos ensinados:

- Separacao entre dados, regra e apresentacao.
- Single Responsibility Principle.
- Teste manual orientado por casos.
- Comparacao simples de colecoes.

Boas praticas:

- A regra de receita deve ficar em uma funcao pequena e nomeada.
- O texto de feedback nao deve ficar espalhado em muitos lugares.
- A UI deve refletir resultado, nao decidir a regra.
- Nao adicionar novas receitas ainda.

Checklist:

- [x] Erva Verde gera sucesso.
- [x] Lavanda sem Erva Verde gera erro.
- [x] Pimenta sem Erva Verde gera erro.
- [x] Misturas com Erva Verde seguem a regra definida no GDD.
- [x] Resultado visual e textual ficam consistentes.

Teste manual:

- Caminho feliz: Erva Verde -> Misturar -> Entregar.
- Caminho errado: Lavanda -> Misturar -> Entregar.
- Caminho invalido: Entregar sem misturar.

Definition of Done:

- O prototipo prova o loop central do GDD do inicio ao fim.

## Sprint 5 - Polimento de UX do prototipo

Status: Concluida.

Objetivo: melhorar clareza e confianca do jogador sem aumentar escopo.

Entregas:

- Feedback textual para ingrediente adicionado.
- Feedback textual para pocao misturada.
- Feedback visual positivo e negativo.
- Estados dos botoes revisados, se necessario.
- Pequena revisao de layout.

Conceitos ensinados:

- Feedback de interacao.
- UX de prototipo.
- Controle de escopo.
- Acessibilidade basica: contraste, legibilidade e tamanho de clique.

Boas praticas:

- Um clique importante deve gerar resposta visivel.
- Texto de estado deve ser curto e direto.
- Botoes indisponiveis podem ser desabilitados quando isso reduzir erro.
- Polimento nao deve virar nova feature.

Checklist:

- [x] O jogador entende quando uma acao funcionou.
- [x] O jogador entende quando uma acao foi invalida.
- [x] O resultado final tem cor ou destaque claro.
- [x] Nao foram adicionados dinheiro, dias, inventario ou clientes extras.

Teste manual:

- Jogar tres rodadas seguidas sem precisar reiniciar a cena pelo editor.

Definition of Done:

- O prototipo parece simples, mas nao confuso.

## Sprint 6 - Revisao tecnica e refatoracao guiada

Status: Concluida.

Objetivo: revisar o que foi feito e melhorar estrutura apenas onde houver ganho real.

Entregas:

- Revisao dos nomes de cenas, nos, variaveis e funcoes.
- Remocao de duplicacao desnecessaria.
- Separacao melhor entre regra e UI, se o codigo pedir isso.
- Registro de decisoes tecnicas aprendidas.

Conceitos ensinados:

- Refatoracao segura.
- SOLID aplicado com moderacao.
- Design patterns como ferramentas, nao decoracao.
- Como avaliar acoplamento e coesao em Godot.

Boas praticas:

- Refatorar depois de ter comportamento funcionando.
- Preservar comportamento durante mudancas internas.
- Evitar criar gerenciadores globais cedo demais.
- Preferir composicao e sinais quando a relacao entre objetos for evento.

Checklist:

- [x] Cada funcao tem um motivo claro para existir.
- [x] A cena principal nao esta fazendo trabalho desnecessario de componentes menores.
- [x] O fluxo ainda funciona depois da refatoracao.
- [x] Foi anotado o que sera deixado para depois do prototipo.

Teste manual:

- Reexecutar todos os testes das sprints anteriores.

Definition of Done:

- O projeto esta pronto para receber uma segunda receita sem reescrever o prototipo inteiro.

## Backlog pos-prototipo

So iniciar depois que o prototipo estiver concluido.

1. Segundo pedido.
2. Segunda receita.
3. Cliente com paciencia.
4. Dinheiro.
5. Reputacao.
6. Evento aleatorio simples.

## Planejamento a partir do GDD completo

Status: Aberto.

O novo GDD define um jogo maior: uma loja de pocoes caotica, em uma tela principal, com clientes, pedidos, receitas, dinheiro, reputacao, eventos aleatorios, dias curtos e caminho ate uma versao publicavel na itch.io.

Decisao principal: o projeto deve evoluir do prototipo atual, nao recomecar do zero. O prototipo provou o loop basico; agora ele vira a base para uma arquitetura mais data-driven.

### Decisoes tomadas

1. Usar Resources customizados desde a proxima fase.

Motivo: ingredientes, receitas, clientes e eventos sao dados do jogo. Na Godot, Resources sao o caminho natural para dados reutilizaveis, editaveis no Inspector e salvos como arquivos `.tres`. Isso ensina uma ferramenta importante da engine e evita que o jogo vire uma pilha de constantes e dictionaries dentro de um unico script.

Resources planejados:

- `IngredientData`
- `RecipeData`
- `CustomerData`
- `RandomEventData`

2. Manter o MVP menor que a versao publicavel.

Motivo: o GDD completo e bom, mas ja descreve um jogo com 7 dias, 6 eventos, audio, arte, menu e telas finais. Isso e escopo de versao publicavel, nao de proxima sprint.

MVP decidido:

- 1 tela principal de gameplay;
- 3 ingredientes;
- 3 receitas;
- 1 cliente por vez;
- barra de paciencia;
- dinheiro;
- reputacao;
- derrota por reputacao 0;
- 2 eventos aleatorios simples;
- reiniciar partida.

3. Separar "jogo funcionando" de "jogo bonito".

Motivo: hoje o projeto parece um formulario porque quase tudo e UI textual. A melhoria visual vira prioridade gradual, mas sem travar os sistemas. Primeiro criamos areas visuais mais expressivas; depois trocamos botoes por icones/sprites e adicionamos animacoes simples.

Direcao visual decidida:

- gameplay continua em uma tela;
- cliente vira uma area visual com retrato ou placeholder;
- ingredientes viram cards/botoes com icone;
- caldeirao vira area central maior;
- HUD fica no topo;
- eventos aparecem como banner;
- resultado vira feedback curto, nao painel dominante.

4. Simplificar os estados do caldeirao em relacao ao GDD.

Motivo: o GDD lista `vazio`, `recebendo ingredientes`, `pronto para misturar`, `pocao pronta`, `entregue`, `limpo`. Para reduzir bugs, nem todos precisam ser estados persistentes.

Estados recomendados:

- `EMPTY`: sem ingredientes;
- `RECEIVING_INGREDIENTS`: ingredientes adicionados, ainda nao misturado;
- `POTION_READY`: mistura feita, pode entregar.

Eventos/transicoes que nao precisam ser estado persistente:

- `limpo`: acao que volta para `EMPTY`;
- `entregue`: acao que resolve cliente e prepara proximo atendimento;
- `pronto para misturar`: pode ser derivado de `RECEIVING_INGREDIENTS` e ingredientes existentes.

5. Nao criar managers globais cedo demais.

Motivo: o GDD sugere muitos managers, mas criar todos agora adicionaria arquitetura antes da necessidade. Vamos extrair responsabilidades quando o script principal comecar a ficar pesado.

Ordem de extracao recomendada:

- primeiro `Cauldron`;
- depois `RecipeBook` ou `RecipeManager`;
- depois `CustomerManager`;
- depois `DayManager`;
- depois `EventManager`;
- por ultimo `AudioManager`.

6. Eventos aleatorios entram depois de cliente, paciencia, dinheiro e reputacao.

Motivo: evento aleatorio sem economia/reputacao/paciencia nao tem onde causar consequencia interessante. Primeiro criamos as regras que os eventos vao modificar.

## Sprint 7 - Dados com Resources customizados

Status: Concluida.

Objetivo: migrar ingredientes e receitas de constantes internas para dados editaveis.

Entregas:

- Pasta `resources/` ou `data/`.
- [x] Script `IngredientData.gd` herdando de `Resource`.
- [x] Script `RecipeData.gd` herdando de `Resource`.
- [x] 3 arquivos `.tres` de ingredientes.
- [x] 3 arquivos `.tres` de receitas.
- [x] `PrototypeGame` ou cena atual usando esses Resources para validar receita.

Conceitos ensinados:

- `Resource`.
- `class_name`.
- `@export`.
- `.tres`.
- Dados separados de comportamento.

Boas praticas:

- Resource guarda dado, nao controla fluxo.
- Node executa comportamento usando dados.
- IDs internos devem continuar estaveis.
- Nomes exibidos podem mudar sem quebrar regra.

Definition of Done:

- Adicionar uma nova receita deve exigir criar/editar um Resource, nao mexer na funcao de validacao.

## Sprint 8 - Refatorar caldeirao para cena propria

Status: Concluida.

Objetivo: tirar a responsabilidade do caldeirao da cena principal.

Entregas:

- [x] Cena `Cauldron.tscn`.
- [x] Script `cauldron.gd`.
- [x] Sinais do caldeirao, como `ingredients_changed`, `potion_mixed` e `cauldron_cleared`.
- [x] Cena principal reagindo ao caldeirao por sinais.

Conceitos ensinados:

- Composicao de cenas.
- Encapsulamento.
- Sinais entre componentes.
- Separacao entre controlador de tela e sistema de jogo.

Boas praticas:

- A cena principal nao deve manipular diretamente a lista interna do caldeirao.
- O caldeirao deve validar limite de ingredientes.
- A UI pode perguntar estado, mas nao deve reconstruir regra.

Definition of Done:

- O caldeirao funciona como componente reutilizavel dentro da cena principal.

## Sprint 9 - Ingredientes como componentes visuais

Status: Concluida.

Objetivo: reduzir a sensacao de formulario e transformar ingredientes em elementos de jogo.

Entregas:

- [x] Cena `IngredientButton.tscn`.
- [x] Script `ingredient_button.gd`.
- [x] Cada botao recebe um `IngredientData`.
- [x] Ingredientes exibem nome e placeholder de icone.
- [x] Sinal `ingredient_selected(ingredient_data)`.

Conceitos ensinados:

- Cena reutilizavel parametrizada.
- Export de Resource em cena.
- Instanciacao ou configuracao manual no Inspector.
- UI data-driven.

Boas praticas:

- Botao de ingrediente nao conhece receita.
- Botao nao mexe no caldeirao diretamente.
- Cada ingrediente visual representa um Resource.

Definition of Done:

- Trocar um ingrediente na tela deve ser feito trocando o Resource associado, nao duplicando codigo.

## Sprint 10 - Cliente e pedido atual

Status: Concluida.

Objetivo: transformar a receita solta em atendimento a cliente.

Entregas:

- [x] `CustomerData`.
- [x] Cena `Customer.tscn` ou painel visual de cliente.
- [x] Pedido atual vindo de uma `RecipeData`.
- [x] Cliente mostra nome, pedido, recompensa e paciencia base.
- [x] Entrega correta/errada afeta o cliente atual.

Conceitos ensinados:

- Dados de cliente.
- Referencia entre Resources.
- Fluxo de atendimento.
- Sinais de cliente satisfeito/irritado.

Boas praticas:

- Cliente deve pedir uma receita, nao um texto solto.
- Texto do pedido deve ser gerado a partir da receita.
- Resultado da entrega resolve o cliente e prepara o proximo.

Definition of Done:

- O jogo atende um cliente real com pedido vindo de dados, nao de constantes fixas.

## Sprint 11 - Fila simples de clientes

Status: Concluida.

Objetivo: criar continuidade de gameplay.

Entregas:

- [x] Lista simples de clientes/pedidos possiveis.
- [x] Proximo cliente aparece apos entrega.
- [x] Caldeirao limpa apos atendimento.
- [x] Contador de clientes atendidos.

Conceitos ensinados:

- Sorteio simples.
- Estado de sessao.
- Reset parcial entre atendimentos.
- Evitar repeticao excessiva.

Boas praticas:

- Separar reset do caldeirao de reset da partida.
- Nao usar aleatoriedade sem controle minimo.
- Manter feedback claro entre um cliente e outro.

Definition of Done:

- O jogador consegue atender varios clientes em sequencia sem reiniciar a cena.

## Sprint 12 - Fundacao visual e placeholders

Objetivo: criar a fundacao visual do jogo antes de adicionar mais sistemas numericos.

Entregas:

- Pasta `assets/` com subpastas iniciais.
- Fundo placeholder da loja.
- Area visual do cliente com espaco para retrato.
- Ingredientes como cards com espaco para icone.
- Caldeirao com area visual mais forte.
- Resultado em formato de feedback curto.
- HUD superior reservado para dia, tempo, dinheiro e reputacao.

Conceitos ensinados:

- `TextureRect`.
- Placeholders visuais.
- Separacao entre view e regra.
- Hierarquia visual de gameplay.
- Preparacao de assets para Web.

Boas praticas:

- Placeholder deve ocupar o mesmo papel do asset final.
- Visual nao deve calcular regra de jogo.
- Dados podem receber campo visual depois, como `icon` e `portrait`.
- Evitar arte final antes de validar fluxo com clientes, dinheiro e paciencia.

Definition of Done:

- Ao rodar o jogo, a tela parece uma loja de pocoes em prototipo visual, nao apenas um formulario.

## Sprint 13 - Dinheiro e reputacao

Objetivo: dar consequencia aos acertos e erros.

Entregas:

- HUD com dinheiro.
- HUD com reputacao.
- Acerto adiciona dinheiro.
- Erro reduz reputacao.
- Reputacao 0 dispara derrota.

Conceitos ensinados:

- Estado de partida.
- Sinais `money_changed` e `reputation_changed`.
- Condicao de derrota.
- HUD como reflexo de estado.

Boas praticas:

- UI nao calcula dinheiro.
- Reputacao deve ter valor minimo e maximo.
- Derrota deve ser uma transicao clara, nao apenas um texto.

Definition of Done:

- O jogador entende por que ganhou, perdeu reputacao ou perdeu a partida.

## Sprint 14 - Barra de paciencia

Objetivo: criar pressao de tempo sem deixar o jogo injusto.

Entregas:

- Barra de paciencia no cliente.
- Timer reduzindo paciencia.
- Cliente vai embora ao chegar em zero.
- Perda de reputacao por cliente perdido.
- Proximo cliente entra automaticamente.

Conceitos ensinados:

- `Timer`.
- Delta/time processado com cuidado.
- ProgressBar.
- Eventos temporais.

Boas praticas:

- Comecar com tempos generosos.
- Feedback visual quando paciencia esta baixa.
- Pausar timer em telas de fim/derrota.

Definition of Done:

- Ignorar um cliente por tempo suficiente causa consequencia clara.

## Sprint 15 - Primeiro EventManager

Objetivo: adicionar caos controlado com dois eventos simples.

Entregas:

- `RandomEventData`.
- `EventManager` local da cena de gameplay.
- Banner de evento.
- Evento `Cliente Apressado`.
- Evento `Promocao Magica`.
- Apenas 1 evento ativo por vez.

Conceitos ensinados:

- Sistemas temporarios.
- Modificadores de regra.
- Sinais de inicio/fim de evento.
- Sorteio ponderado simples.

Boas praticas:

- Evento deve ter inicio, duracao e fim.
- Evento deve deixar claro o que alterou.
- Eventos nao devem quebrar regras basicas do jogo.

Definition of Done:

- Eventos mudam a partida de forma perceptivel e terminam sem deixar estado sujo.

## Sprint 16 - Dia curto e tela de fim de dia

Objetivo: transformar atendimentos soltos em ciclo de dia.

Entregas:

- Timer do dia.
- Resumo de fim de dia.
- Clientes atendidos.
- Erros.
- Dinheiro do dia.
- Botao para iniciar proximo dia.

Conceitos ensinados:

- Loop de sessao.
- Separacao entre dia e partida.
- Tela/modal de resumo.
- Reset controlado de estado.

Boas praticas:

- Dia 1 curto para teste.
- Resumo deve mostrar informacao util, nao texto decorativo.
- Proximo dia deve alterar poucos parametros por vez.

Definition of Done:

- Uma partida tem comeco, meio e fim de dia.

## Sprint 17 - Progressao ate 7 dias

Objetivo: implementar a estrutura de campanha curta.

Entregas:

- Dia atual.
- Desbloqueio gradual de ingredientes/receitas/eventos.
- Ajuste de paciencia e frequencia de eventos por dia.
- Condicao de vitoria ao final do Dia 7.

Conceitos ensinados:

- Curva de dificuldade.
- Dados por dia.
- Balanceamento simples.
- Vitoria e derrota.

Boas praticas:

- Aumentar complexidade em camadas.
- Nao acelerar demais.
- Registrar parametros em dados, nao em ifs espalhados.

Definition of Done:

- O jogador pode vencer ou perder uma campanha curta.

## Sprint 18 - Reestrutura visual da tela principal

Objetivo: sair da aparencia de formulario e aproximar a tela de jogo.

Entregas:

- HUD no topo.
- Cliente em area visual propria.
- Caldeirao como foco central.
- Ingredientes como icones/cards.
- Banner de evento separado.
- Resultado como toast/texto curto.

Conceitos ensinados:

- UI de jogo.
- Hierarquia visual.
- Layout responsivo.
- Separacao entre HUD, gameplay e feedback.

Boas praticas:

- Uma tela de jogo deve mostrar prioridade visual.
- O caldeirao e o cliente devem parecer elementos do mundo, nao apenas labels.
- Prototipo visual pode usar placeholders antes da arte final.

Definition of Done:

- Ao olhar a tela, ela parece uma loja de pocoes jogavel, nao um formulario de teste.

## Sprint 19 - Audio e feedback sensorial

Objetivo: adicionar resposta sensorial basica.

Entregas:

- Sons de clique, mistura, acerto, erro e moeda.
- Feedback visual de acerto/erro.
- Pequena animacao ou tween no caldeirao.
- Feedback de paciencia baixa.

Conceitos ensinados:

- AudioStreamPlayer.
- Tweens.
- Feedback multimodal.
- Polimento com baixo custo.

Boas praticas:

- Audio deve confirmar acao, nao irritar.
- Feedback visual e sonoro devem concordar.
- Volume deve ser moderado.

Definition of Done:

- Jogar sem olhar o Output ainda comunica as principais acoes.

## Sprint 20 - Menu, derrota e vitoria

Objetivo: fechar o ciclo de jogo publicavel.

Entregas:

- Menu principal.
- Tela de como jogar.
- Tela de derrota.
- Tela de vitoria.
- Reiniciar partida.
- Voltar ao menu.

Conceitos ensinados:

- Troca de cenas.
- Estado inicial limpo.
- Fluxo completo de usuario.
- Preparacao para build.

Boas praticas:

- Reiniciar nao deve deixar estado antigo.
- Menu deve ser simples.
- Como jogar deve ensinar em poucos passos.

Definition of Done:

- O jogo pode ser jogado do menu ate vitoria/derrota sem usar o editor.

## Sprint 21 - Export Web e publicacao itch.io

Objetivo: gerar uma versao jogavel fora do editor.

Entregas:

- Configuracao de export Web.
- Build testada localmente.
- Ajustes de resolucao.
- Pagina itch.io simples.
- Checklist de publicacao.

Conceitos ensinados:

- Export presets.
- Web build.
- Teste fora do editor.
- Empacotamento.

Boas praticas:

- Build final deve ser testada como jogador.
- Controles e UI precisam funcionar no navegador.
- Publicar uma versao pequena e melhor que eternizar polimento.

Definition of Done:

- Existe uma build Web jogavel e compartilhavel.

## Quadro de controle

| Sprint | Status | Observacoes |
| --- | --- | --- |
| Sprint 0 | Concluida | Cena `Game` criada, salva e validada com F5 |
| Sprint 1 | Concluida | Interface principal montada e validada com F5 |
| Sprint 2 | Concluida | Botoes de ingredientes conectados por sinais |
| Sprint 3 | Concluida | Estados principais do caldeirao implementados; reinicio segue para Sprint 4 |
| Sprint 4 | Concluida | Receita validada, resultado exibido na UI e reinicio conectado |
| Sprint 5 | Concluida | Feedback visual, estado de botoes e regras can_* aplicadas |
| Sprint 6 | Concluida | Revisao tecnica concluida; regras can_* e receita em lista prepararam expansao |
| Sprint 7 | Concluida | IngredientData, RecipeData, .tres e lookup por id integrados |
| Sprint 8 | Concluida | Cauldron extraido para cena/script proprio com sinais |
| Sprint 9 | Concluida | IngredientButton reutilizavel com IngredientData |
| Sprint 10 | Concluida | CustomerData integrado com CustomerView e pedido por receita |
| Sprint 11 | Concluida | Fila simples de clientes funcionando |
| Sprint 12 | A fazer | Fundacao visual e placeholders |
| Sprint 13 | A fazer | Dinheiro e reputacao |
| Sprint 14 | A fazer | Barra de paciencia |
| Sprint 15 | A fazer | EventManager com 2 eventos |
| Sprint 16 | A fazer | Dia curto e fim de dia |
| Sprint 17 | A fazer | Progressao ate 7 dias |
| Sprint 18 | A fazer | Reestrutura visual da gameplay |
| Sprint 19 | A fazer | Audio e feedback sensorial |
| Sprint 20 | A fazer | Menu, derrota e vitoria |
| Sprint 21 | A fazer | Export Web e itch.io |
