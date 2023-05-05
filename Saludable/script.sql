--\c postgres;
--Me ahorro de dropearla manualmente
DROP DATABASE IF EXISTS turnos;

CREATE DATABASE turnos;

\c turnos;

--Creacion de tablas
CREATE TABLE medico(matricula int UNIQUE,nombre text,id_horario SERIAL);
CREATE TABLE paciente(id_paciente SERIAL UNIQUE, nombre text, dni char(8),id_obra_social int);
CREATE TABLE turno(id_turno SERIAL UNIQUE,id_paciente int,id_servicio int,matricula int, fecha timestamp);
CREATE TABLE servicio_medico(id_servicio SERIAL UNIQUE, especialidad text);
CREATE TABLE equipo(id_equipo SERIAL UNIQUE,id_servicio int,nombre text);
CREATE TABLE obra_social(id_obra_social SERIAL UNIQUE,nombre text);
CREATE TABLE horario_atencion(id_horario SERIAL UNIQUE,franja text);


--Creacion de PKs y FKs
ALTER TABLE medico ADD CONSTRAINT medico_pk PRIMARY KEY(matricula);
ALTER TABLE paciente ADD CONSTRAINT paciente_pk PRIMARY KEY(id_paciente);
ALTER TABLE turno ADD CONSTRAINT turno_pk PRIMARY KEY(id_turno);
ALTER TABLE servicio_medico ADD CONSTRAINT servicio_pk PRIMARY KEY(id_servicio);
ALTER TABLE equipo ADD CONSTRAINT equipo_pk PRIMARY KEY(id_equipo);
ALTER TABLE obra_social ADD CONSTRAINT obra_social_pk PRIMARY KEY(id_obra_social);
ALTER TABLE horario_atencion ADD CONSTRAINT horario_pk PRIMARY KEY(id_horario);
ALTER TABLE paciente ADD CONSTRAINT paciente_obra_fk FOREIGN KEY(id_obra_social) REFERENCES obra_social(id_obra_social);
ALTER TABLE equipo ADD CONSTRAINT equipo_servicio_fk FOREIGN KEY(id_servicio) REFERENCES servicio_medico(id_servicio);
ALTER TABLE turno ADD CONSTRAINT turno_paciente_fk FOREIGN KEY(id_paciente) REFERENCES paciente(id_paciente);
ALTER TABLE turno ADD CONSTRAINT turno_servicio_fk FOREIGN KEY(id_servicio) REFERENCES servicio_medico(id_servicio);
ALTER TABLE turno ADD CONSTRAINT turno_medico_fk FOREIGN KEY(matricula) REFERENCES medico(matricula);
ALTER TABLE medico ADD CONSTRAINT medico_horario_fk FOREIGN KEY(id_horario) REFERENCES horario_atencion(id_horario);

--Trigger (funcion)
CREATE OR REPLACE FUNCTION atencion_publico() RETURNS trigger AS $$
BEGIN
	IF (extract(hour from NEW.fecha)>20 OR extract(hour from NEW.fecha)<8) 
	OR (date_part('dow',now())=6 AND extract(hour from NEW.fecha)>20  OR extract(hour from NEW.fecha)<8) OR (date_part('dow',now())=7)
	THEN
		RAISE NOTICE 'La atencion al publico es de L a V de 8 a 20hs y S de 8 a 14hs';
	ELSE 
		RETURN NEW;
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--Trigger
CREATE TRIGGER comprobar_horario
	BEFORE INSERT
	ON turno
	FOR EACH ROW
	EXECUTE PROCEDURE atencion_publico();

--Inserts
insert into obra_social values(DEFAULT,'PAMI');
insert into obra_social values(DEFAULT,'OSDE 210');
insert into obra_social values(DEFAULT,'IOMA');
insert into paciente values(DEFAULT,'Han Solo','24593201',1);
insert into paciente values(DEFAULT,'Ellen Ripley','42237917',2);
insert into paciente values(DEFAULT,'Sarah Connor','20059021',3);
insert into horario_atencion values(DEFAULT,'L a V de 8 a 17');
insert into horario_atencion values(DEFAULT,'L a V de 8 a 17');
insert into medico values(15987432,'Gregory House',1);
insert into medico values(98456377,'Stephen Strange',1);
insert into servicio_medico values(DEFAULT,'Neurologia');
insert into servicio_medico values(DEFAULT,'Cirugia');
insert into equipo values(DEFAULT,1,'Monitores de paciente');
insert into equipo values(DEFAULT,1,'Cascos EEG');
insert into equipo values(DEFAULT,2,'Monitores de anestesia');
insert into equipo values(DEFAULT,2,'Camilla');
insert into turno values(DEFAULT,1,1,15987432,'2023-05-16 22:05:06');--Se intenta insertar un turno fuera del horario de atencion
insert into turno values(DEFAULT,3,2,15987432,'2023-08-30 14:15:00');
insert into turno values(DEFAULT,1,2,98456377,'2023-10-31 12:45:00');
insert into turno values(DEFAULT,2,2,98456377,'2023-04-10 15:30:00');

