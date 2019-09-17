CREATE OR REPLACE FUNCTION fechaletra(date)
  RETURNS pg_catalog.text AS $BODY$
declare
pfecha alias for $1;

ptexto text;

pmes char(2);
pdia char(2);
pano char(4);
psmes text;

begin

  pmes:=cast(date_part('month',pfecha) as char(2));
  pdia:=cast(date_part('day',pfecha) as char(2));
  pano:=cast(date_part('year',pfecha) as char(4));

  if pmes=1 then
    psmes := 'Enero     ';
  end if;
  if pmes=2 then
    psmes := 'Febrero   ';
  end if;
  if pmes=3 then
    psmes := 'Marzo     ';
  end if;
  if pmes=4 then
    psmes := 'Abril     ';
  end if;
  if pmes=5 then
    psmes := 'Mayo      ';
  end if;
  if pmes=6 then
    psmes := 'Junio     ';
  end if;
  if pmes=7 then
    psmes := 'Julio     ';
  end if;
  if pmes=8 then
    psmes := 'Agosto    ';
  end if;
  if pmes=9 then
    psmes := 'Septiembre';
  end if;
  if pmes=10 then
    psmes := 'Octubre   ';
  end if;
  if pmes=11 then
    psmes := 'Noviembre ';
  end if;
  if pmes=12 then
    psmes := 'Diciembre ';
  end if;

  ptexto:=pdia||' DE '||rtrim(upper(psmes))||' DE '||pano;


  return ptexto;
end
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
