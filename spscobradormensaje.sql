CREATE OR REPLACE FUNCTION spscobradormensaje(text)
  RETURNS SETOF tcobrador AS $BODY$
declare
  pfiltro alias for $1; 
  r tcobrador%rowtype;
  filtro text;
begin
    filtro := pfiltro || '%';
    for r in
      select c.cobradorid,j.sujetoid,j.paterno,j.materno,j.nombre,j.razonsocial
        from cobradores c, sujeto j
       where c.activo='S' and j.sujetoid = c.sujetoid and         
             (j.sujetoid like filtro or
              (j.nombre||' '||j.paterno||' '||j.materno) like filtro or
              (j.paterno||' '||j.materno||' '||j.nombre) like filtro or
	      j.razonsocial like filtro)
      order by j.sujetoid
    loop
      return next r;
    end loop;
return;
end
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
