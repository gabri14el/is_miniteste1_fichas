#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat May  1 00:15:37 2021

@author: gabriel

TEM QUE SE INSTALAR O WATCHDOG E O CONECTOR DO PYTHON PARA O MYSQL
pip install mysql-connector-python watchdog
"""

import sys
import time
import logging
import os
from watchdog.observers import Observer
from watchdog.events import LoggingEventHandler
from watchdog.events import FileSystemEventHandler

import mysql.connector


class Handler(FileSystemEventHandler):
    
    cnx = mysql.connector.connect(
    host="127.0.0.1",
    port=3306,
    user="root",
    password="gs",
    database='aula4')
    
    
    
    def on_any_event(self, event):
        if event.is_directory:
            return None
  
        elif event.event_type == 'created':
            # Event is created, you can process it now
            print("Watchdog received created event - % s." % event.src_path)
        elif event.event_type == 'modified':
            # Event is modified, you can process it now
            print("Watchdog received modified event - % s." % event.src_path)
            
            file = event.src_path.split(os.path.sep)[-1]
            tabela = file.split('-')
            cur = self.cnx.cursor()
            
            if os.path.exists(event.src_path):
                f = open(event.src_path, "r")
                linha = f.readline()
                pedacos_linha = linha.split(',')
                print(linha) 
                
                str_exec = None
                if tabela[0] == 'aluno':
                    if tabela[1] == 'ins':
                        str_exec = "insert into Student(number, name, address) values ({}, '{}', '{}')".format(pedacos_linha[0], pedacos_linha[1], pedacos_linha[2])
                    elif tabela[1] == 'upd':
                        str_exec = "update Student set name='{}' and address = '{}' where number={}".format(pedacos_linha[1], pedacos_linha[2], pedacos_linha[0])
                    elif tabela[1] == 'del':
                        str_exec = "delete from Student where number={}".format(pedacos_linha[0])
                    pass
                
                elif tabela[0] == 'emp':
                    if tabela[1] == 'ins':
                        str_exec = "insert into Loan(number_student, number_book, date_loan) values ({}, {}, STR_TO_DATE('{}','%Y-%m-%d'))".format(pedacos_linha[0], pedacos_linha[1], pedacos_linha[2])
                    elif tabela[1] == 'upd':
                        str_exec ="update Loan set date_received = STR_TO_DATE('{}','%Y-%m-%d') where number_student = {} and number_book = {} and date_loan = STR_TO_DATE('{}','%Y-%m-%d')".format(pedacos_linha[3], pedacos_linha[0], pedacos_linha[1], pedacos_linha[2])
                    elif tabela[1] == 'del':
                        str_exec = "delete from Loan where number_student = {} and number_book = {} and date_loan = STR_TO_DATE('{}','%Y-%m-%d')".format(pedacos_linha[0], pedacos_linha[1], pedacos_linha[2])
                
                elif tabela[0] == 'livro':
                    if tabela[1] == 'ins':
                        str_exec = "insert into Book(number, title, author) values ({}, '{}', '{}')".format(pedacos_linha[0], pedacos_linha[1], pedacos_linha[2])
                    elif tabela[1] == 'del':
                        str_exec = 'delete from Book where number = {} '.format(pedacos_linha[0])
                    pass
                
                #escreve no banco de dados
                if not str_exec is None:
                    print(str_exec)
                    cur.execute(str_exec)
                    self.cnx.commit()
if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(message)s',
                        datefmt='%Y-%m-%d %H:%M:%S')
    path = '/tmp/'
    event_handler = Handler()
    observer = Observer()
    observer.schedule(event_handler, path, recursive=False)
    observer.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()