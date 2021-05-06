#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May  6 20:08:48 2021

@author: gabriel
"""
import psycopg2 as pg

class Storage():
    
    def __init__(self):
        
        #cria conexoes
        self.alunos_conn = pg.connect(
                        host="localhost",
                        database="ficha4",
                        user="user_alunos",
                        password="senha")
        self.livros_conn = pg.connect(
                        host="localhost",
                        database="ficha4",
                        user="user_livro",
                        password="senha")
        self.emprestimo_conn = pg.connect(
                        host="localhost",
                        database="ficha4",
                        user="user_emprestimo",
                        password="senha")
        self.emprestimo_conn.autocommit = True
        self.livros_conn.autocommit = True
        self.alunos_conn.autocommit = True
        
        
    def encerra_conexoes(self):
        self.alunos_conn.close()
        self.livros_conn.close()
        self.emprestimo_conn.close()
    
    def listar_alunos(self):
        cur = self.alunos_conn.cursor()
        cur.execute("select listaralunos()");
        
        alunos = cur.fetchall()
        cur.close()
        return alunos;
    
    def listar_livros(self):
        cur = self.livros_conn.cursor()
        cur.execute("select listarlivros()");
        
        livros = cur.fetchall()
        cur.close()
        return livros;
    
    def novo_emprestimo(self, aluno, livro, data):
        cur = self.emprestimo_conn.cursor()
        #cur.execute("START TRANSACTION;")
        cur.execute("CALL novoemprestimo({}, {}, '{}');".format(aluno, livro, data))
        #cur.callproc("novoemprestimo", (aluno, livro, data))
        #cur.commit()
        
        cur.close()
    
    def devolver_emprestimo(self, aluno, livro, data, data_devolucao):
        cur = self.emprestimo_conn.cursor()
        cur.execute("call devolucaoemprestimo({}, {}, '{}', '{}');".format(aluno, livro, data, data_devolucao))
        
        cur.close()
    
        
        


storage = Storage()
continua = True
while(continua):
    
    print('Escreva a opção correspondente:\n 1 - Listar Alunos\n 2 - Listar Livros\n 3 - Cadastrar Novo Emprestimo\n 4 - Cadastrar Devolução de Livro\n 5 - Sair');
    opcao = int(input())
    
    if(opcao == 5):
        continua = False
    if opcao == 1:
        print('Alunos: ')
        [print(x[0]) for x in storage.listar_alunos()]
    if opcao == 2:
        print('Livros: ')
        [print(x[0]) for x in storage.listar_livros()]
    if opcao == 3:
        aluno = int(input('Digite o número do aluno: '))
        livro = int(input('Digite o número do livro: '))
        data = input('Digite a data do empréstimo (DD/MM/YYYY): ')
        storage.novo_emprestimo(aluno, livro, data)
    if opcao == 4:
        aluno = int(input('Digite o número do aluno: '))
        livro = int(input('Digite o número do livro: '))
        data = input('Digite a data do empréstimo (DD/MM/YYYY): ')
        data_devolucao = input('Digite a data da devolução (DD/MM/YYYY): ')
        storage.devolver_emprestimo(aluno, livro, data, data_devolucao)
        
        