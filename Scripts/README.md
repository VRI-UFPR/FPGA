# O que falta fazer
* Verificar se precisa de algum pacote adicional para o mint
* Mudar o script do digilent para pegar a versao pelo nome do arquivo
* Adicionar no inicio uma verificacao para so executar caso seja mint ou arch
* Remover os pacotes adicionais instalados no final
* Mudar o scipt inicial para chamar o verify python
* Deixar o script do digilent mais legivel
* Adicionar um docker para o mint

# Como contribuir
* Baixe o docker
* Rode ```docker build -t ise-webpack . && docker run --rm -it ise-webpack```

# Como usar
* Os arquivos do xilinx e do digilent precisam ser baixados na mao e colocados
  em uma pasta "digilent" e "xilinx" nesse diretorio

