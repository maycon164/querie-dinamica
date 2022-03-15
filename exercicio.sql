CREATE DATABASE bd_exemplo;

CREATE TABLE produto(
	codigo int primary key,
	nome varchar(100),
	valor decimal(10,2)
)

INSERT INTO produto VALUES (1, 'caneta', 10.99);
INSERT INTO produto VALUES (2, 'lapis', 2.99);
INSERT INTO produto VALUES (3, 'caderno', 1.99);
INSERT INTO produto VALUES (4, 'cola', 10.00);
INSERT INTO produto VALUES (5, 'tesoura', 5.00);
INSERT INTO produto VALUES (6, 'estojo', 9.00);

CREATE TABLE entrada(
	codigo_transacao INT PRIMARY KEY IDENTITY(1,1),
	codigo_produto INT NOT NULL,
	quantidade INT NOT NULL,
	valor_total DECIMAL(10,2)

	FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
)

CREATE TABLE saida(
	codigo_transacao INT PRIMARY KEY IDENTITY(1,1),
	codigo_produto INT NOT NULL,
	quantidade INT NOT NULL,
	valor_total DECIMAL(10,2)
	FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
)


CREATE PROCEDURE sp_registra_log(
	@codigo_transacao char(1), 
	@codigo_produto INT,
	@quantidade INT, 
	@saida varchar(max) OUTPUT 
)
AS
	DECLARE @query VARCHAR(MAX),
		@tabela VARCHAR(MAX),
		@valor_total DECIMAL(10, 2),
		@valor_produto DECIMAL(10, 2)
BEGIN
	
		SELECT @valor_produto = valor FROM produto WHERE codigo = @codigo_produto;
		
		IF(@valor_produto IS NOT NULL)

			BEGIN
				SET @valor_total = @quantidade * @valor_produto;

				IF @codigo_transacao = 'e' 
					BEGIN
						SET @tabela = 'entrada';
					END
				ELSE IF @codigo_transacao = 's' 
					BEGIN
						SET @tabela = 'saida';
					END
				ELSE 
					BEGIN
						RAISERROR('opcao invalida', 16, 1);
					END
			
				SET @query = 'INSERT INTO '+@tabela+' (codigo_produto, quantidade, valor_total ) VALUES (' +CAST(@codigo_produto AS VARCHAR(10))+ ', ' +CAST(@quantidade AS VARCHAR(10))+ ', ' +CAST(@valor_total AS VARCHAR(10))+ ' )';
				
				EXEC (@query);
				SET @saida = UPPER(@tabela)+' inserido com sucesso';
			
			END
		ELSE
			BEGIN
				RAISERROR('PRODUTO NAO ENCONTRADO', 16, 1);
			END
END


DECLARE @saida varchar(max)
EXEC sp_registra_log '12asdadsadasd', 1111, 4, @saida OUTPUT
PRINT @saida

DECLARE @saida varchar(max)
EXEC sp_registra_log 'sasda', 16, 4, @saida OUTPUT
PRINT @saida

select * from entrada;
select * from saida;
