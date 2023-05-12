\c postgres
DROP DATABASE IF EXISTS blog;

CREATE DATABASE blog;
\c blog


CREATE TABLE usuario(id_usuario SERIAL UNIQUE,nombre text, apellido text,id_direccion SERIAL,id_telefono SERIAL);
CREATE TABLE direccion(id_direccion SERIAL UNIQUE,calle text,numero int,cod_postal int,ciudad text,pais text);
CREATE TABLE comentario(id_comentario SERIAL UNIQUE,contenido text,fecha date,id_usuario SERIAL);
CREATE TABLE noticia(id_noticia SERIAL UNIQUE,titulo text,cuerpo text,fecha_publicacion date,id_usuario SERIAL);
CREATE TABLE tag(id_tag SERIAL UNIQUE, nombre text);
CREATE TABLE telefono(id_telefono SERIAL UNIQUE, numero text);
CREATE TABLE noticia_tag(id SERIAL UNIQUE,id_noticia SERIAL,id_tag SERIAL);


--PKs
ALTER TABLE usuario ADD CONSTRAINT usuario_pk PRIMARY KEY(id_usuario);
ALTER TABLE direccion ADD CONSTRAINT direccion_pk PRIMARY KEY(id_direccion);
ALTER TABLE comentario ADD CONSTRAINT comentario_pk PRIMARY KEY(id_comentario);
ALTER TABLE noticia ADD CONSTRAINT noticia_pk PRIMARY KEY(id_noticia);
ALTER TABLE tag ADD CONSTRAINT tag_pk PRIMARY KEY(id_tag);
ALTER TABLE telefono ADD CONSTRAINT telefono_pk PRIMARY KEY(id_telefono);
ALTER TABLE noticia_tag ADD CONSTRAINT noticia_tag_pk PRIMARY KEY(id);

--FKs
ALTER TABLE usuario ADD CONSTRAINT usuario_direccion_fk FOREIGN KEY(id_direccion) REFERENCES direccion(id_direccion);
ALTER TABLE usuario ADD CONSTRAINT usuario_telefono_fk FOREIGN KEY(id_telefono) REFERENCES telefono(id_telefono);
ALTER TABLE noticia_tag ADD CONSTRAINT noticia_fk FOREIGN KEY(id_noticia) REFERENCES noticia(id_noticia); 
ALTER TABLE noticia_tag ADD CONSTRAINT tag_fk FOREIGN KEY(id_tag) REFERENCES tag(id_tag);
ALTER TABLE comentario ADD CONSTRAINT usuario_fk FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario);

--Inserts
INSERT INTO telefono values(DEFAULT,'1165995380');
INSERT INTO telefono values(DEFAULT,'1153756049');
INSERT INTO telefono values(DEFAULT,'1198774320');
INSERT INTO direccion values(DEFAULT, 'San Nicolas',5097,1665,'Jose C. Paz','Argentina');
INSERT INTO direccion values(DEFAULT, 'D Elia',1849,1668,'San Miguel','Argentina');
INSERT INTO direccion values(DEFAULT, 'Juan M. Gutierrez',449,1666,'Polvorines','Argentina');
INSERT INTO tag values(DEFAULT,'Economia');
INSERT INTO usuario values(DEFAULT, 'Ezequiel','Palacio',1,1);
INSERT INTO usuario values(DEFAULT, 'Nicolas','Perez',2,2);
INSERT INTO noticia values (DEFAULT,'Bajo el dolar en Argentina','En el dia de la fecha el dolar bajo 99%','2023-05-05',1);
INSERT INTO noticia_tag values(DEFAULT,1,1);
INSERT INTO comentario values(DEFAULT,'Buena noticia. Muy Informativa.','2023-05-10',2);

