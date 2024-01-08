--  tabella vendite
CREATE TABLE vendite (
    id_transazione INT PRIMARY KEY,
    categoria_prodotto VARCHAR(50),
    costo_vendita DECIMAL(10, 2),
    sconto DECIMAL(5, 2)
);

--  tabella dettagli_vendite
CREATE TABLE dettagli_vendite (
    id_cliente INT,
    id_transazione INT,
    data_transazione DATE,
    quantita INT,
    PRIMARY KEY (id_cliente, id_transazione),
    FOREIGN KEY (id_transazione) REFERENCES vendite(id_transazione)
);

-- Creazione della tabella ClientiFedeli
CREATE TABLE ClientiFedeli (
    IDCliente INT,
    IDVendita INT,
    Nome_Cliente VARCHAR(50),
    PRIMARY KEY (IDCliente, IDVendita, Nome_Cliente)
);

-- Inserimento di dati di esempio nella tabella ClientiFedeli
INSERT INTO ClientiFedeli VALUES
(1, 101, 'ROSSI FEDERICO'),
(1, 102, 'ROSSI FEDERICO'),
(2, 103, 'NOME_CLIENTE'),
(3, 104, 'NOME_CLIENTE'),
(4, 105, 'NOME_CLIENTE'),
(4, 106, 'NOME_CLIENTE'),
(4, 107, 'NOME_CLIENTE'),
(5, 108, 'NOME_CLIENTE'),
(5, 109, 'NOME_CLIENTE');

--  dati nella tabella vendite
INSERT INTO vendite VALUES
(1, 'Frigo', 500.00, 60),
(2, 'Telefono', 200.00, 5),
(3, 'PC', 300.00, 15),
(4, 'Forno', 150.00, 50),
(5, 'Tastiera', 20.00, 15),
(6, 'Mouse', 5.00, 15),
(7, 'Console', 350.00, 70),
(8, 'Tablet', 600.00, 15),
(9, 'Watch', 330.00, 15),
(10, 'Cuffie', 400.00, 20);

--  dati nella tabella dettagli_vendite
INSERT INTO dettagli_vendite VALUES
(01, 1, '2024-01-01', 2),
(02, 2, '2024-01-01', 1),
(03, 2, '2023-01-02', 5),
(04, 1, '2024-01-03', 2),
(05, 1, '2023-05-03', 3),
(06, 2, '2023-06-10', 7),
(07, 5, '2023-01-10', 2),
(08, 5, '2023-06-10', 3),
(09, 1, '2024-01-01', 1),
(10, 6, '2023-08-07', 6),
(11, 1, '2023-01-03', 5),
(12, 2, '2023-03-08', 3),
(13, 1, '2023-01-07', 4),
(14, 8, '2023-12-05', 10),
(15, 9, '2024-01-01', 23),
(16, 1, '2023-09-05', 8),
(17, 10, '2023-10-05',1),
(18, 6, '2023-08-07', 6),
(19, 1, '2023-01-03', 1),
(20, 2, '2023-03-08', 3),
(21, 1, '2023-01-07', 6),
(22, 8, '2023-11-05', 1),
(23, 9, '2024-01-01', 3),
(24, 1, '2023-07-1', 10),
(25, 10, '2023-08-09',1);

-- Seleziona tutte le vendite avvenute in una specifica data (es. '2024-01-01')
SELECT *
FROM vendite v
JOIN dettagli_vendite dv ON v.id_transazione = dv.id_transazione
WHERE dv.data_transazione = '2024-01-01';

-- Seleziona le vendite con sconti maggiori del 50%
SELECT *
FROM vendite
WHERE sconto >= 50;

-- Calcola il totale del costo delle vendite per categoria dalla tabella dettagli_vendite
SELECT
    v.categoria_prodotto,
    SUM(v.costo_vendita * dv.quantita) AS totale_costo_vendite
FROM dettagli_vendite dv
JOIN vendite v ON dv.id_transazione = v.id_transazione
GROUP BY v.categoria_prodotto;

-- Trova il numero totale di prodotti venduti per ogni categoria.
SELECT
    v.categoria_prodotto,
    SUM(dv.quantita) AS totale_vendite
FROM dettagli_vendite dv
JOIN vendite v ON dv.id_transazione = v.id_transazione
GROUP BY v.categoria_prodotto;

-- Seleziona le vendite dell'ultimo trimestre
SELECT *
FROM dettagli_vendite
WHERE data_transazione >= DATE_SUB(NOW(), INTERVAL 3 MONTH);

-- Raggruppa le vendite per mese e calcola il totale delle vendite per ogni mese

SELECT MONTH(data_transazione) AS mese, SUM(costo_vendita) AS totale_vendite
FROM dettagli_vendite , vendite
GROUP BY mese;

-- Trova la categoria con lo sconto medio più alto

SELECT categoria_prodotto, AVG(sconto) AS sconto_medio
FROM vendite
GROUP BY categoria_prodotto
ORDER BY sconto_medio DESC
LIMIT 1;

-- Confronta le vendite mese per mese per vedere l'incremento o il decremento delle vendite. Calcola l'incremento o decremento mese per mese
SELECT
    MONTH(data_transazione) AS mese,
    SUM(costo_vendita) AS totale_vendite,
    LAG(SUM(costo_vendita)) OVER (ORDER BY MONTH(data_transazione)) AS vendite_mese_precedente,
    COALESCE(SUM(costo_vendita) - LAG(SUM(costo_vendita)) OVER (ORDER BY MONTH(data_transazione)), 0) AS variazione
FROM dettagli_vendite, vendite
GROUP BY mese
ORDER BY mese;


-- Confronta le vendite totali in diverse stagioni
SELECT
    CASE
        WHEN MONTH(data_transazione) IN (12, 1, 2) THEN 'Inverno'
        WHEN MONTH(data_transazione) IN (3, 4, 5) THEN 'Primavera'
        WHEN MONTH(data_transazione) IN (6, 7, 8) THEN 'Estate'
        WHEN MONTH(data_transazione) IN (9, 10, 11) THEN 'Autunno'
    END AS stagione,
    SUM(costo_vendita) AS totale_vendite
FROM dettagli_vendite, vendite
GROUP BY stagione;



-- Query per trovare i top 5 clienti con il maggior numero di acquisti
SELECT
    IDCliente,
    COUNT(IDVendita) AS numero_acquisti
FROM ClientiFedeli
GROUP BY IDCliente
ORDER BY numero_acquisti DESC
LIMIT 5;

-- Calcola il totale delle vendite per categoria e ordina per vendite decrescenti
SELECT
    categoria_prodotto,
    SUM(costo_vendita) AS totale_vendite
FROM vendite, dettagli_vendite
GROUP BY categoria_prodotto
ORDER BY totale_vendite DESC;





