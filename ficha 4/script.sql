--create database ficha4;
CREATE USER user_alunos WITH PASSWORD 'senha';

-- cria a tabela aluno
CREATE TABLE public."Aluno" (
    numero_aluno serial NOT NULL,
    nome text NOT NULL,
    endereco text,
    garantia text,
    CONSTRAINT "Aluno_pkey" PRIMARY KEY (numero_aluno)
);

-- define o dono para alunos
ALTER TABLE public."Aluno" OWNER TO user_alunos;

GRANT ALL PRIVILEGES ON "Aluno" TO user_alunos;

-- insere aluno
CREATE OR REPLACE PROCEDURE public.insereAluno (IN nome_new text, IN endereco_new text, IN garantia_new text)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    INSERT INTO "Aluno" (nome, endereco, garantia)
        VALUES (nome_new, endereco_new, garantia_new);
    COMMIT;
END;
$BODY$;

-- update aluno
CREATE OR REPLACE PROCEDURE public.updatealuno (IN n_aluno bigint, IN ende text, IN gar text)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    UPDATE
        "Aluno"
    SET
        endereco = ende,
        garantia = gar
    WHERE
        numero_aluno = n_aluno;
    COMMIT;
END;
$BODY$;

-- deleta aluno
CREATE OR REPLACE PROCEDURE public.deletealuno (IN n_aluno bigint)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    DELETE FROM "Aluno"
    WHERE numero_aluno = n_aluno;
    COMMIT;
END;
$BODY$;

-- Triggers: alunoinseridotrigger
CREATE FUNCTION public.alunoinserido ()
    RETURNS TRIGGER
    LANGUAGE 'plpgsql'
    AS $BODY$
BEGIN
    EXECUTE format($$COPY (SELECT * from "Aluno" where "numero_aluno" = %s) TO '/tmp/aluno-ins-%s.csv' WITH CSV$$, NEW.numero_aluno, NEW.numero_aluno);
    RETURN NEW;
END;
$BODY$;

-- da para o usuario a parada
ALTER FUNCTION public.alunoinserido () OWNER TO user_alunos;

CREATE TRIGGER alunoinseridotrigger
    AFTER INSERT ON public."Aluno"
    FOR EACH ROW
    EXECUTE FUNCTION public.alunoinserido ();

-----

CREATE FUNCTION public.alunoapagado ()
    RETURNS TRIGGER
    LANGUAGE 'plpgsql'
    AS $BODY$
BEGIN
    EXECUTE format($$COPY (SELECT * from "Aluno" where "numero_aluno" = %s) TO '/tmp/aluno-del-%s.csv' WITH CSV$$, OLD.numero_aluno, OLD.numero_aluno);
    RETURN OLD;
END;
$BODY$;

-- da para o usuario a parada
ALTER FUNCTION public.alunoapagado () OWNER TO user_alunos;

CREATE TRIGGER alunoapagadotrigger
    AFTER DELETE ON public."Aluno"
    FOR EACH ROW
    EXECUTE FUNCTION public.alunoapagado();

--- 
CREATE FUNCTION public.alunoatualizado ()
    RETURNS TRIGGER
    LANGUAGE 'plpgsql'
    AS $BODY$
BEGIN
    EXECUTE format($$COPY (SELECT * from "Aluno" where "numero_aluno" = %s) TO '/tmp/aluno-upd-%s.csv' WITH CSV$$, NEW.numero_aluno, NEW.numero_aluno);
    RETURN NEW;
END;
$BODY$;

-- da para o usuario a parada
ALTER FUNCTION public.alunoatualizado () OWNER TO user_alunos;

CREATE TRIGGER alunoatualizadotrigger
    AFTER UPDATE ON public."Aluno"
    FOR EACH ROW
    EXECUTE FUNCTION public.alunoatualizado();


--===========================
-- LIVROS
--===========================
CREATE USER user_livro WITH PASSWORD 'senha';

CREATE TABLE public."Livro" (
    numero_livro serial NOT NULL,
    titulo text NOT NULL,
    autor text NOT NULL,
    editor text,
    data_compra date,
    estado text,
    CONSTRAINT livro_pkey PRIMARY KEY (numero_livro)
);

ALTER TABLE public."Livro" OWNER TO user_livro;

GRANT ALL PRIVILEGES ON "Livro" TO user_livro;

-- insere livro
CREATE OR REPLACE PROCEDURE public.insereLivro (IN titulo_new text, IN autor_new text, IN editor_new text, IN data_compra_new text, IN estado_new text)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    INSERT INTO "Livro" (titulo, autor, editor, data_compra, estado)
        VALUES (titulo_new, autor_new, editor_new, TO_DATE(data_compra_new, 'DD/MM/YYYY'), estado_new);
    COMMIT;
END;
$BODY$;

-- deleta livro
CREATE OR REPLACE PROCEDURE public.deleteLivro (IN n_livro bigint)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    DELETE FROM "Livro"
    WHERE numero_livro = n_livro;
    COMMIT;
END;
$BODY$;

-- Trigger: alunoinseridotrigger
CREATE FUNCTION public.livroinserido ()
    RETURNS TRIGGER
    LANGUAGE 'plpgsql'
    AS $BODY$
BEGIN
    EXECUTE format($$COPY (SELECT * from "Livro" where "numero_livro" = %s) TO '/tmp/livro-ins-%s.csv' WITH CSV$$, NEW.numero_livro, NEW.numero_livro);
    RETURN NEW;
END;
$BODY$;

-- da para o usuario a parada
ALTER FUNCTION public.livroinserido () OWNER TO user_livro;

CREATE TRIGGER livroinseridotrigger
    AFTER INSERT ON public."Livro"
    FOR EACH ROW
    EXECUTE FUNCTION public.livroinserido ();

-----
CREATE FUNCTION public.livroatualizado ()
    RETURNS TRIGGER
    LANGUAGE 'plpgsql'
    AS $BODY$
BEGIN
    EXECUTE format($$COPY (SELECT * from "Livro" where "numero_livro" = %s) TO '/tmp/livro-upd-%s.csv' WITH CSV$$, NEW.numero_livro, NEW.numero_livro);
    RETURN NEW;
END;
$BODY$;

-- da para o usuario a parada
ALTER FUNCTION public.livroatualizado () OWNER TO user_livro;

CREATE TRIGGER livroatualizadotrigger
    AFTER UPDATE ON public."Livro"
    FOR EACH ROW
    EXECUTE FUNCTION public.livroatualizado ();


-----
CREATE FUNCTION public.livroapagado ()
    RETURNS TRIGGER
    LANGUAGE 'plpgsql'
    AS $BODY$
BEGIN
    EXECUTE format($$COPY (SELECT * from "Livro" where "numero_livro" = %s) TO '/tmp/livro-del-%s.csv' WITH CSV$$, OLD.numero_livro, OLD.numero_livro);
    RETURN OLD;
END;
$BODY$;

-- da para o usuario a parada
ALTER FUNCTION public.livroapagado () OWNER TO user_livro;

CREATE TRIGGER livroapagado
    AFTER DELETE ON public."Livro"
    FOR EACH ROW
    EXECUTE FUNCTION public.livroapagado();

--===========================
-- Emprestimo
--===========================
CREATE USER user_emprestimo WITH PASSWORD 'senha';

CREATE TABLE public."Emprestimo" (
    numero_aluno bigint NOT NULL,
    numero_livro bigint NOT NULL,
    data_requisicao date NOT NULL,
    data_entrega date,
    CONSTRAINT "Emprestimo_pkey" PRIMARY KEY (numero_aluno, numero_livro, data_requisicao),
    CONSTRAINT aluno_fk FOREIGN KEY (numero_aluno) REFERENCES public."Aluno" (numero_aluno),
    CONSTRAINT livro_fk FOREIGN KEY (numero_livro) REFERENCES public."Livro" (numero_livro)
);

ALTER TABLE public."Emprestimo" OWNER TO user_emprestimo;

GRANT ALL PRIVILEGES ON "Emprestimo" TO user_emprestimo;

-- criacao de um novo emprestimo
CREATE OR REPLACE PROCEDURE public.novoemprestimo (numero_aluno_new bigint, numero_livro_new bigint, data_requisicao_new text)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    INSERT INTO "Emprestimo" (numero_aluno, numero_livro, data_requisicao)
        VALUES (numero_aluno_new, numero_livro_new, TO_DATE(data_requisicao_new, 'DD/MM/YYYY'));
    COMMIT;
END;
$BODY$;

-- devolucao de emprestimo
CREATE OR REPLACE PROCEDURE public.devolucaoemprestimo (numero_aluno_new bigint, numero_livro_new bigint, data_requisicao_new text, data_devolucao_new text)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    UPDATE
        "Emprestimo"
    SET
        data_entrega = TO_DATE(data_devolucao_new, 'DD/MM/YYYY')
    WHERE
        data_requisicao = TO_DATE(data_requisicao_new, 'DD/MM/YYYY')
        AND numero_aluno = numero_aluno_new
        AND numero_livro = numero_livro_new;
    COMMIT;
END;
$BODY$;

-- Trigger: alunoinseridotrigger
-- cria o trigger depois do inserir ou update basicamente para verificar as alteracoes dos banco de dados
CREATE FUNCTION public.emprestimoinserido ()
    RETURNS TRIGGER
    LANGUAGE 'plpgsql'
    AS $BODY$
BEGIN
    EXECUTE format($$COPY (SELECT * from "Emprestimo" where "numero_livro" = %s and "numero_aluno" = %s and "data_requisicao" = TO_DATE('%s', 'DD/MM/YYYY')) TO '/tmp/emp-ins-%s-%s.csv' WITH CSV$$, NEW.numero_livro, NEW.numero_aluno, TO_CHAR(NEW.data_requisicao, 'DD/MM/YYYY'), NEW.numero_livro, NEW.numero_aluno);
    RETURN NEW;
END;
$BODY$;

-- da para o usuario a parada
ALTER FUNCTION public.emprestimoinserido () OWNER TO user_emprestimo;

CREATE TRIGGER empretimoinseridotrigger
    AFTER INSERT ON public."Emprestimo"
    FOR EACH ROW
    EXECUTE FUNCTION public.emprestimoinserido ();

CREATE FUNCTION public.emprestimoremovido ()
    RETURNS TRIGGER
    LANGUAGE 'plpgsql'
    AS $BODY$
BEGIN
    EXECUTE format($$COPY (select * from "Emprestimo" where "numero_livro" = %s and "numero_aluno" = %s and "data_requisicao" = TO_DATE('%s', 'DD/MM/YYYY')) TO '/tmp/emp-del-%s-%s.csv' WITH CSV$$, OLD.numero_livro, OLD.numero_aluno, TO_CHAR(OLD.data_requisicao, 'DD/MM/YYYY'), OLD.numero_livro, OLD.numero_aluno);
    RETURN OLD;
END;
$BODY$;

-- da para o usuario a parada
ALTER FUNCTION public.emprestimoremovido () OWNER TO user_emprestimo;

CREATE TRIGGER emprestimoremovidotrigger
    BEFORE DELETE ON public."Emprestimo"
    FOR EACH ROW
    EXECUTE FUNCTION public.emprestimoremovido ();

---------- update
CREATE FUNCTION public.emprestimoupdate ()
    RETURNS TRIGGER
    LANGUAGE 'plpgsql'
    AS $BODY$
BEGIN
    EXECUTE format($$COPY (select * from "Emprestimo" where "numero_livro" = %s and "numero_aluno" = %s and "data_requisicao" = TO_DATE('%s', 'DD/MM/YYYY')) TO '/tmp/emp-upd-%s-%s.csv' WITH CSV$$, NEW.numero_livro, NEW.numero_aluno, TO_CHAR(NEW.data_requisicao, 'DD/MM/YYYY'), NEW.numero_livro, NEW.numero_aluno);
    RETURN NEW;
END;
$BODY$;

-- da para o usuario a parada
ALTER FUNCTION public.emprestimoupdate () OWNER TO user_emprestimo;

CREATE TRIGGER eemprestimoupdatetrigger
    AFTER UPDATE ON public."Emprestimo"
    FOR EACH ROW
    EXECUTE FUNCTION public.emprestimoupdate ();

GRANT pg_write_server_files TO user_alunos;

GRANT pg_write_server_files TO user_livro;

GRANT pg_write_server_files TO user_emprestimo;


--funcoes 
create or replace FUNCTION public.listaralunos()
  returns TABLE (numero   integer,  nome text) 
AS
$func$
  SELECT  numero_aluno, nome
  FROM "Aluno";
$func$ 
LANGUAGE sql;

--funcoes 
create or replace FUNCTION public.listaralivros()
  returns TABLE (numero   integer,  titulo text, autor text) 
AS
$func$
  SELECT  numero_livro, titulo, autor
  FROM "Livro";
$func$ 
LANGUAGE sql;






call inserealuno('Gabriel Carneiro','travessa de timor', '');
call inserelivro('DL with Python','François Chollet', '', '22/03/2020', 'Novo');
call novoemprestimo(3, 3, '05/05/2020');
call devolucaoemprestimo(3, 3, '05/05/2020', '06/05/2020');
select listaralunos();
