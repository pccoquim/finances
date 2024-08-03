-- Criar a base de dados
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ff')
BEGIN
    CREATE DATABASE ff;
END
GO


-- Criar o utilizador
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'familyfinance')
BEGIN
	CREATE LOGIN familyfinance WITH PASSWORD = '#KgD32581';
END
GO

-- Usar a base de dados criada
USE ff;
GO

-- Atribuir controlo sobre a base de dados
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'familyfinance')
BEGIN
    CREATE USER familyfinance FOR LOGIN familyfinance;
END
GO

-- Dar controle total ao usuário sobre a base de dados 'ff'
ALTER ROLE db_owner ADD MEMBER familyfinance;
GO

-- Criar a tabela status
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tbl_0001_status') AND type in (N'U'))
BEGIN
	CREATE TABLE tbl_0001_status(
		stt_id INT IDENTITY(1,1) PRIMARY KEY,
		stt_cod VARCHAR(1) NOT NULL,
		stt_descr VARCHAR(30) NOT NULL,
		stt_usercreation VARCHAR(30) NOT NULL,
		stt_datecreation VARCHAR(8) NOT NULL,
		stt_timecreation VARCHAR(6) NOT NULL,
		stt_userlstchg VARCHAR(30) NOT NULL,
		stt_datelstchg VARCHAR(8) NOT NULL,
		stt_timelstchg VARCHAR(6) NOT NULL,
		);
END
GO
	
-- Criar a tabela users
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0002_users') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0002_users(
		usr_id INT IDENTITY(1,1) PRIMARY KEY, 
		usr_userID VARCHAR(30) NOT NULL,
		usr_name VARCHAR(100) NOT NULL,
		usr_password VARCHAR(255) NOT NULL,
		usr_type VARCHAR(50) NOT NULL,
		usr_status VARCHAR(1) NOT NULL,
		usr_chgpw BIT NOT NULL,
		usr_pwcount INT NOT NULL,
		usr_usercreation VARCHAR(30) NOT NULL,
		usr_datecreation VARCHAR(8) NOT NULL,
		usr_timecreation VARCHAR(6) NOT NULL,
		usr_userlstchg VARCHAR(30) NOT NULL,
		usr_datelstchg VARCHAR(8) NOT NULL,
		usr_timelstchg VARCHAR(6) NOT NULL,
		usr_userlstchgpw VARCHAR(30) NOT NULL,
		usr_datelstchgpw VARCHAR(8) NOT NULL,
		usr_timelstchgpw VARCHAR(6) NOT NULL,
		CONSTRAINT FK_usr_status FOREIGN KEY (usr_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO

-- Criar a tabela opecoesMenu
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0003_opcoesAcesso') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0003_opcoesAcesso(
		opm_id INT IDENTITY(1,1) PRIMARY KEY,
		opm_cod VARCHAR(30) NOT NULL,
		opm_descr VARCHAR(255) NOT NULL,
		opm_nivel INT NOT NULL,
		opm_status VARCHAR(1) NOT NULL,
		opm_usercreation VARCHAR(30)NOT NULL,
		opm_datecreation VARCHAR(8) NOT NULL,
		opm_timecreation VARCHAR(6) NOT NULL,
		opm_userlstchg VARCHAR(30) NOT NULL,
		opm_datelstchg VARCHAR(8) NOT NULL,
		opm_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_opm_status FOREIGN KEY (opm_status) REFERENCES tbl_0001_status(stt_cod),
		CONSTRAINT FK_opm_usercreation FOREIGN KEY (opm_usercreation) REFERENCES tbl_0002_users(usr_userID)
		);
END
GO

-- Criar tabela acessos de utilizadores
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0004_acessos') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0004_acessos(
		acs_id INT IDENTITY(1,1) PRIMARY KEY,
		acs_userid INT NOT NULL,
		acs_cod VARCHAR(30) NOT NULL,
		acs_acesso BIT NOT NULL DEFAULT 0,
		acs_usercreation VARCHAR(30)NOT NULL,
		acs_datecreation VARCHAR(8) NOT NULL,
		acs_timecreation VARCHAR(6) NOT NULL,
		acs_userlstchg VARCHAR(30) NOT NULL,
		acs_datelstchg VARCHAR(8) NOT NULL,
		acs_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_acs_userid FOREIGN KEY (acs_userid) REFERENCES tbl_0002_users(usr_userID)
		);
END
GO

- Criar tabela paises
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0005_paises') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0005_paises(
		pai_id INT IDENTITY(1,1) PRIMARY KEY,
		pai_desig VARCHAR(50) NOT NULL,
		pai_iso3166_1_number INT NOT NULL,
		pai_iso3166_1_alpha2 VARCHAR(2) NOT NULL,
		pai_iso3166_1_alpha3 VARCHAR(3) NOT NULL,
		pai_status VARCHAR(1) NOT NULL,
		pai_usercreation VARCHAR(30)NOT NULL,
		pai_datecreation VARCHAR(8) NOT NULL,
		pai_timecreation VARCHAR(6) NOT NULL,
		pai_userlstchg VARCHAR(30) NOT NULL,
		pai_datelstchg VARCHAR(8) NOT NULL,
		pai_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_pai_status FOREIGN KEY (pai_status) REFERENCES tbl_0001_status(stt_cod),
		CONSTRAINT FK_pai_usercreation FOREIGN KEY (pai_usercreation) REFERENCES tbl_0002_users(usr_userID)
		);
END
GO

-- Criar tabela tipos de terceiros
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0101_tipoterceiro') AND type in (N'U')
BEGIN
	create TABLE tbl_0101_tipoterceiro(
		ttc_id INT IDENTITY(1,1) PRIMARY KEY,
		ttc_cod VARCHAR(2) NOT NULL,
		ttc_descr VARCHAR(50) NOT NULL,
		ttc_status VARCHAR(1) NOT NULL,
		ttc_usercreation VARCHAR(30)NOT NULL,
		ttc_datecreation VARCHAR(8) NOT NULL,
		ttc_timecreation VARCHAR(6) NOT NULL,
		ttc_userlstchg VARCHAR(30) NOT NULL,
		ttc_datelstchg VARCHAR(8) NOT NULL,
		ttc_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_ttc_status FOREIGN KEY (ttc_status) REFERENCES tbl_0001_status(stt_cod),
		CONSTRAINT FK_ttc_usercreation FOREIGN KEY (ttc_usercreation) REFERENCES tbl_0002_users(usr_userID)
		);
END
GO

-- Criar tabela terceiros
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0102_terceiros') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0102_terceiros(
		trc_id INT IDENTITY(1,1) PRIMARY KEY,
		trc_cod VARCHAR(3) NOT NULL,
		trc_descr VARCHAR(110) NOT NULL,
		trc_codtipo VARCHAR(2) NOT NULL,
		trc_morada1 VARCHAR(50) NOT NULL,
		trc_morada2 VARCHAR(50),
		trc_cp VARCHAR(20) NOT NULL,
		trc_localidade VARCHAR(50) NOT NULL,
		trc_pais INT NOT NULL,
		trc_nif VARCHAR(20) NOT NULL,
		trc_tlf VARCHAR(20) NOT NULL DEFAULT 0,
		trc_email VARCHAR(50) NOT NULL DEFAULT 0,
		trc_status VARCHAR(1) NOT NULL,
		trc_usercreation VARCHAR(30)NOT NULL,
		trc_datecreation VARCHAR(8) NOT NULL,
		trc_timecreation VARCHAR(6) NOT NULL,
		trc_userlstchg VARCHAR(30) NOT NULL,
		trc_datelstchg VARCHAR(8) NOT NULL,
		trc_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_trc_codtipo FOREIGN KEY (trc_codtipo) REFERENCES tbl_0101_tipoterceiro(ttc_cod),
		CONSTRAINT FK_pai_usercreation FOREIGN KEY (pai_usercreation) REFERENCES tbl_0002_users(usr_userID),
		CONSTRAINT FK_trc_status FOREIGN KEY (trc_status) REFERENCES tbl_0001_status(stt_cod),
		CONSTRAINT FK_trc_usercreation FOREIGN KEY (trc_usercreation) REFERENCES tbl_0002_users(usr_userID)
		);
END
GO
	
-- Criar tabela contas crédito
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0103_contascred') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0103_contascred(
		ctc_id INT IDENTITY(1,1) PRIMARY KEY,
		ctc_cod VARCHAR(3) NOT NULL,
		ctc_descr VARCHAR(110) NOT NULL,
		ctc_nr VARCHAR(50) NOT NULL DEFAULT 0,
		ctc_saldo DECIMAL(18, 2) NOT NULL DEFAULT 0,
		ctc_status VARCHAR(1) NOT NULL,
		ctc_usercreation VARCHAR(30)NOT NULL,
		ctc_datecreation VARCHAR(8) NOT NULL,
		ctc_timecreation VARCHAR(6) NOT NULL,
		ctc_userlstchg VARCHAR(30) NOT NULL,
		ctc_datelstchg VARCHAR(8) NOT NULL,
		ctc_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_ctc_status FOREIGN KEY (ctc_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO
	
-- Criar tabela contas dédito
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0103_contasdeb') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0103_contasdeb(
		ctb_id INT IDENTITY(1,1) PRIMARY KEY,
		ctd_cod VARCHAR(3) NOT NULL,
		ctd_descr VARCHAR(110) NOT NULL,
		ctd_nr VARCHAR(50) NOT NULL DEFAULT 0,
		ctd_status VARCHAR(1) NOT NULL,
		ctd_usercreation VARCHAR(30)NOT NULL,
		ctd_datecreation VARCHAR(8) NOT NULL,
		ctd_timecreation VARCHAR(6) NOT NULL,
		ctd_userlstchg VARCHAR(30) NOT NULL,
		ctd_datelstchg VARCHAR(8) NOT NULL,
		ctd_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_ctd_status FOREIGN KEY (ctd_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO

-- Criar tabela tipo de receita
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0104_tiporeceita') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0104_tiporeceita(
		tr_id INT IDENTITY(1,1) PRIMARY KEY,
		tr_cod VARCHAR(3) NOT NULL,
		tr_descr VARCHAR(110) NOT NULL,
		tr_status VARCHAR(1) NOT NULL,
		tr_usercreation VARCHAR(30)NOT NULL,
		tr_datecreation VARCHAR(8) NOT NULL,
		tr_timecreation VARCHAR(6) NOT NULL,
		tr_userlstchg VARCHAR(30) NOT NULL,
		tr_datelstchg VARCHAR(8) NOT NULL,
		tr_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_tr_status FOREIGN KEY (tr_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO

-- Criar tabela familias
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0201_familias') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0201_familias(
		fam_id INT IDENTITY(1,1) PRIMARY KEY,
		fam_codigo VARCHAR(2) NOT NULL,
		fam_descr VARCHAR(50) NOT NULL,
		fam_status VARCHAR(1) NOT NULL,
		fam_usercreation VARCHAR(30)NOT NULL,
		fam_datecreation VARCHAR(8) NOT NULL,
		fam_timecreation VARCHAR(6) NOT NULL,
		fam_userlstchg VARCHAR(30) NOT NULL,
		fam_datelstchg VARCHAR(8) NOT NULL,
		fam_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_pai_status FOREIGN KEY (pai_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO

-- Criar tabela sub-familias
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0202_subfamilias') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0202_subfamilias(
		sfm_id INT IDENTITY(1,1) PRIMARY KEY,
		sfm_codfam VARCHAR(2) NOT NULL,
		sfm_cod VARCHAR(3) NOT NULL,
		sfm_codigo VARCHAR(5) NOT NULL,
		sfm_descr VARCHAR(50) NOT NULL,
		sfm_status VARCHAR(1) NOT NULL,
		sfm_usercreation VARCHAR(30)NOT NULL,
		sfm_datecreation VARCHAR(8) NOT NULL,
		sfm_timecreation VARCHAR(6) NOT NULL,
		sfm_userlstchg VARCHAR(30) NOT NULL,
		sfm_datelstchg VARCHAR(8) NOT NULL,
		sfm_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_sfm_status FOREIGN KEY (sfm_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO

-- Criar tabela grupos
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0203_grupos') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0203_grupos(
		grp_id INT IDENTITY(1,1) PRIMARY KEY,
		grp_codsubfam VARCHAR(5) NOT NULL,
		grp_cod VARCHAR(3) NOT NULL,
		grp_codigo VARCHAR(8) NOT NULL,
		grp_descr VARCHAR(50) NOT NULL,
		grp_status VARCHAR(1) NOT NULL,
		grp_usercreation VARCHAR(30)NOT NULL,
		grp_datecreation VARCHAR(8) NOT NULL,
		grp_timecreation VARCHAR(6) NOT NULL,
		grp_userlstchg VARCHAR(30) NOT NULL,
		grp_datelstchg VARCHAR(8) NOT NULL,
		grp_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_grp_status FOREIGN KEY (grp_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO

-- Criar tabela unidades
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0204_unidades') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0204_unidades(
		uni_id INT IDENTITY(1,1) PRIMARY KEY,
		uni_cod VARCHAR(3) NOT NULL,
		uni_descr VARCHAR(50) NOT NULL,
		uni_peso DECIMAL(9,3) NOT NULL DEFAULT 0,
		uni_volume DECIMAL(9,3) NOT NULL DEFAULT 0,
		uni_status VARCHAR(1) NOT NULL,
		uni_usercreation VARCHAR(30)NOT NULL,
		uni_datecreation VARCHAR(8) NOT NULL,
		uni_timecreation VARCHAR(6) NOT NULL,
		uni_userlstchg VARCHAR(30) NOT NULL,
		uni_datelstchg VARCHAR(8) NOT NULL,
		uni_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_uni_status FOREIGN KEY (uni_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO

-- Criar tabela viaturas
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0205_viaturas') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0205_viaturas(
		vtr_id INT IDENTITY(1,1) PRIMARY KEY,
		vtr_cod VARCHAR(2) NOT NULL,
		vtr_matricula VARCHAR(8) NOT NULL,
		vtr_descr VARCHAR(50) NOT NULL,
		vtr_status VARCHAR(1) NOT NULL,
		vtr_usercreation VARCHAR(30)NOT NULL,
		vtr_datecreation VARCHAR(8) NOT NULL,
		vtr_timecreation VARCHAR(6) NOT NULL,
		vtr_userlstchg VARCHAR(30) NOT NULL,
		vtr_datelstchg VARCHAR(8) NOT NULL,
		vtr_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_vtr_status FOREIGN KEY (vtr_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO

-- Criar tabela taxas IVA
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0206_taxasiva') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0206_taxasiva(
		iva_id INT IDENTITY(1,1) PRIMARY KEY,
		iva_cod VARCHAR(2) NOT NULL,
		iva_taxa DECIMAL(5,2) NOT NULL,
		iva_status VARCHAR(1) NOT NULL,
		iva_usercreation VARCHAR(30)NOT NULL,
		iva_datecreation VARCHAR(8) NOT NULL,
		iva_timecreation VARCHAR(6) NOT NULL,
		iva_userlstchg VARCHAR(30) NOT NULL,
		iva_datelstchg VARCHAR(8) NOT NULL,
		iva_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_iva_status FOREIGN KEY (iva_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO

-- Criar tabela artigos
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0207_artigos') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0207_artigos(
		art_id INT IDENTITY(1,1) PRIMARY KEY,
		art_codgrupo VARCHAR(8) NOT NULL,
		art_cod VARCHAR(6) NOT NULL,
		art_coduni VARCHAR(3) NOT NULL,
		art_codterc VARCHAR(3) NOT NULL,
		art_codigo VARCHAR(20) NOT NULL,
		art_descr VARCHAR(50) NOT NULL,
		art_status VARCHAR(1) NOT NULL,
		art_usercreation VARCHAR(30)NOT NULL,
		art_datecreation VARCHAR(8) NOT NULL,
		art_timecreation VARCHAR(6) NOT NULL,
		art_userlstchg VARCHAR(30) NOT NULL,
		art_datelstchg VARCHAR(8) NOT NULL,
		art_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_art_status FOREIGN KEY (art_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO
	
-- Criar tabela movimentos a débito
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0301_movimentosdebito') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0301_movimentosdebito(
		fd_id INT IDENTITY(1,1) PRIMARY KEY,
		fd_id_fatura INT NOT NULL,
		fd_codterc VARCHAR(3) NOT NULL,
		fd_numdoc VARCHAR(50) NOT NULL,
		fd_datadoc VARCHAR(8) NOT NULL DEFAULT 0,
		fd_datalimitepag VARCHAR(8) NOT NULL DEFAULT 0,
		fd_dataemissaodoc VARCHAR(8) NOT NULL DEFAULT 0,
		fd_conta VARCHAR(3) NOT NULL,
		fd_valor DECIMAL(15, 2) NOT NULL,
		fd_status VARCHAR(1) NOT NULL,
		fd_usercreation VARCHAR(30)NOT NULL,
		fd_datecreation VARCHAR(8) NOT NULL,
		fd_timecreation VARCHAR(6) NOT NULL,
		fd_userlstchg VARCHAR(30) NOT NULL,
		fd_datelstchg VARCHAR(8) NOT NULL,
		fd_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_fd_status FOREIGN KEY (fd_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO
	
-- Criar tabela de detalhes de movimentos a débito 
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0302_movimentosdebito_det') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0302_movimentosdebito_det(
		md_id INT IDENTITY(1,1) PRIMARY KEY,
		md_id_fatura INT NOT NULL,
		md_id_linha INT NOT NULL,
		md_codartigo VARCHAR(20) NOT NULL,
		md_codiva VARCHAR(2) NOT NULL,
		md_datamov VARCHAR(8) NOT NULL,
		md_quantidade DECIMAL(15,4) NOT NULL,
		md_precobase DECIMAL(15,4) NOT NULL,
		md_desconto1 DECIMAL(7,4) NOT NULL DEFAULT 0,
		md_desconto2 DECIMAL(7,4) NOT NULL DEFAULT 0,
		md_precofinal DECIMAL(15,4) NOT NULL,
		md_valordesconto DECIMAL(15,4) NOT NULL,
		md_combustivel BIT NOT NULL DEFAULT 0,
		md_codviatura VARCHAR(2) NOT NULL DEFAULT 0,
		md_kmi INT NOT NULL DEFAULT 0,
		md_kmf INT NOT NULL DEFAULT 0,
		md_kmefetuados INT NOT NULL DEFAULT 0,
		md_status VARCHAR(1) NOT NULL,
		md_usercreation VARCHAR(30)NOT NULL,
		md_datecreation VARCHAR(8) NOT NULL,
		md_timecreation VARCHAR(6) NOT NULL,
		md_userlstchg VARCHAR(30) NOT NULL,
		md_datelstchg VARCHAR(8) NOT NULL,
		md_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_md_status FOREIGN KEY (md_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO

-- Criar tabela movimentos a crébito 
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE object_id = OBJECT_ID(N'tbl_0402_movimentoscredito') AND type in (N'U')
BEGIN
	CREATE TABLE tbl_0402_movimentoscredito(
		mc_id INT IDENTITY(1,1) PRIMARY KEY,
		mc_cred_id INT NOT NULL,
		mc_codterc VARCHAR(3) NOT NULL,
		mc_numerodoc VARCHAR(50) NOT NULL,
		mc_datamov VARCHAR(8) NOT NULL,
		mc_codtiporeceita VARCHAR(3) NOT NULL,
		mc_contacredito VARCHAR(3) NOT NULL,
		mc_contadebito VARCHAR(3) NOT NULL,
		mc_valor DECIMAL(15,2) NOT NULL,
		mc_transf BIT NOT NULL DEFAULT 0,
		mc_status VARCHAR(1) NOT NULL,
		mc_usercreation VARCHAR(30)NOT NULL,
		mc_datecreation VARCHAR(8) NOT NULL,
		mc_timecreation VARCHAR(6) NOT NULL,
		mc_userlstchg VARCHAR(30) NOT NULL,
		mc_datelstchg VARCHAR(8) NOT NULL,
		mc_timelstchg VARCHAR(6) NOT NULL,
		CONSTRAINT FK_mc_status FOREIGN KEY (mc_status) REFERENCES tbl_0001_status(stt_cod)
		);
END
GO

-- Valores constantes de estado
INSERT INTO tbl_0001_status (stt_cod, stt_descr, stt_usrcreation, stt_datecreation, stt_timecreation, stt_userlstchg, stt_datelstchg, stt_timelstchg)
VALUES  ("1", "Ativo", "Master", "19000101", "000001", "0", "0", "0"),
		("2", "Inativo", "Master", "19000101", "000001", "0", "0", "0");
-- Criação do utilizador "Admin", administrador de todo o software
INSERT INTO tbl_0002_users (usr_userID, usr_name, usr_password, usr_type, usr_status, usr_chgpw, usr_pwcount, usr_usercreation, usr_datecreation, usr_timecreation, usr_userlstchg, usr_datelstchg, usr_timelstchg)
VALUES ("Master", "Administrador", "!@#$%^&*", "Administrador", "1", "0", "0", "Master", "19000101", "000001", "0", "0", "0");
-- Valores dos menus iniciais
INSERT INTO tbl_0003_opcoesacesso (opm_cod, opm_descr, opm_nivel, opm_status, opm_usercreation, opm_datecreation, opm_timecreation, opm_userlstchg, opm_datelstchg, opm_timelstchg)
VALUES  ("M01", "Ficheiro", "1", "1", "Master", "19000101", "000001", "0", "0", "0"),
		("M01L01", "Ficheiro / Login", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M01O01", "Ficheiro / Logout", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M01S01", "Ficheiro / Sair", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
		("M20", "Entidades", "1", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20U01", "Entidades / Utilizadores", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20U0101", "Entidades / Utilizadores / Manutenção de utilizadores", "3", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20U0102", "Entidades / Utilizadores / Manutenção de acessos", "3", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20U010101", "Adicionar utilizadores", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20U010102", "Alterar utilizadores", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20U010103", "Eliminar utilizadores", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20U010104", "Alterar palavra-passe a utilizadores", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20U010105", "Adicionar acessos a utilizadores", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20U010201", "Adicionar acesso", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20U010202", "Alterar acesso", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20U010203", "Eliminar acesso", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20T01", "Entidades / Terceiros", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20T0101", "Entidades / Terceiros / Manutenção de tipos de terceiros", "3", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20T010101", "Adicionar tipo de terceiro", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20T010102", "Alterar tipo de terceiro", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20T010103", "Eliminar tipo de terceiro", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20T0102", "Entidades / Terceiros / Manutenção de terceiros", "3", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20T010201", "Adicionar terceiros", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20T010202", "Alterar terceiros", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20T010203", "Eliminar terceiros", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20C01", "Entidades / Contas", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20C0101", "Entidades / Contas / Manutenção de contas", "3", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20C010101", "Adicionar contas", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20C010102", "Alterar contas", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20C010103", "Eliminar contas", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20C0102", "Entidades / Contas / Manutenção de tipos de receitas", "3", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20C010201", "Adicionar tipos de receitas", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20C010202", "Alterar tipos de receitas", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20C010203", "Eliminar tipos de receitas", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M01", "Entidades / Movimentação", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M0101", "Entidades / Movimentação / Manutenção geral", "3", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M0102", "Entidades / Movimentação / Manutenção de familias", "3", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010201", "Adicionar familias", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010202", "Alterar familias", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010203", "Eliminar familias", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M0103", "Entidades / Movimentação / Manutenção de sub-familias", "3", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010301", "Adicionar sub-familias", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010302", "Alterar sub-familias", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010303", "Eliminar sub-familias", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M0104", "Entidades / Movimentação / Manutenção de grupos", "3", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010401", "Adicionar grupos", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010402", "Alterar grupos", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010403", "Eliminar grupos", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M0105", "Entidades / Movimentação / Manutenção de artigos", "3", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010501", "Adicionar artigos", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010502", "Alterar artigos", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010503", "Eliminar artigos", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M0106", "Entidades / Movimentação / Manutenção de unidades", "3", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010601", "Adicionar unidades", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010602", "Alterar unidades", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20M010603", "Eliminar unidades", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20V0101", "Entidades / viaturas", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20V010101", "Adicionar viaturas", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20V010102", "Alterar viaturas", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M20V010103", "Eliminar viaturas", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25", "Movimentação", "1", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25C01", "Movimentação / Crédito", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25C0101", "Adicionar movimentos a crédito", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25C0102", "Alterar movimentos a crédito", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25C0103", "Eliminar movimentos a crédito", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25D01", "Movimentação / Débitos - cabeçalho", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25D0101", "Adicionar cabeçalhos de movimento a débito", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25D0102", "Alterar cabeçalhos de movimento a débito", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25D0103", "Eliminar cabeçalhos de movimento a débito", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25D02", "Movimentação / Débitos - detalhe", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25D0201", "Adicionar detalhe (linha) de movimento a débito", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25D0202", "Alterar detalhe (linha) de movimento a débito", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M25D0203", "Eliminar detalhe (linha) de movimento a débito", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
		("M25V02", "Movimentação / Registo de manutenção de viaturas", "20", "1", "Master", "19000101", "000001", "0", "0", "0"),
		("M28", "Relatórios", "1", "1", "Master", "19000101", "000001", "0", "0", "0"),
		("M28A0101", "Relatório por artigo/mês com seleção de ano", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
		("M28A0102", "Relatório por grupo/mês com seleção de ano", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
		("M28A0103", "Relatório por subfamilia/mês com seleção de ano", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
		("M28A0104", "Relatório por familia/mês com seleção de ano", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
		("M28A0201", "Relatório de saldo/mês com seleção de ano", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
	    ("M30", "Configurações", "1", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M30D01", "Configurações / Localização da base de dados", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M30D02", "Configurações / Backup da base de dados", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M30D03", "Configurações / Restaurar a base de dados", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M40", "Utilitários", "1", "1", "Master", "19000101", "000001", "0", "0", "0"),
		("M40A01", "Alterar Palavra-passe", "2", "1", "Master", "19000101", "000001", "0", "0", "0"),
        ("M90", "Ajuda", "1", "1", "Master", "19000101", "000001", "0", "0", "0");