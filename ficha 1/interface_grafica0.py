# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout, QHBoxLayout, QLineEdit, QLabel


app = QApplication([])
window = QWidget()


#layout botoes

layout_bt = QHBoxLayout()
#botoes
bt_add = QPushButton('Adicionar')
bt_remover = QPushButton('Remover')
bt_listar = QPushButton('Listar')
layout_bt.addWidget(bt_add)
layout_bt.addWidget(bt_remover)
layout_bt.addWidget(bt_listar)


layout_wt = QHBoxLayout()
layout_wt_wt = QVBoxLayout()
layout_wt_lb = QVBoxLayout()

wt_numero = QLineEdit()
wt_nome = QLineEdit()
wt_email = QLineEdit()

wts = [wt_numero, wt_nome, wt_email]

lb_numero = QLabel('Numero')
lb_nome = QLabel('Nome')
lb_email = QLabel('E-mail')


layout_wt_lb.addWidget(lb_numero)
layout_wt_wt.addWidget(wt_numero)


layout_wt_lb.addWidget(lb_nome)
layout_wt_wt.addWidget(wt_nome)


layout_wt_lb.addWidget(lb_email)
layout_wt_wt.addWidget(wt_email)

layout_wt.addLayout(layout_wt_lb)
layout_wt.addLayout(layout_wt_wt)


layout = QVBoxLayout()
layout.addLayout(layout_wt)
layout.addLayout(layout_bt)

def zeraTextoBotoes(checked):
    for wt in wts:
        wt.setText('')
        
bt_add.clicked.connect(zeraTextoBotoes)

window.setLayout(layout)
window.show()
app.exec()