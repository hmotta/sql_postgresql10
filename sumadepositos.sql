CREATE OR REPLACE FUNCTION sumadepositos(bpchar, date, int4)
  RETURNS pg_catalog.numeric AS $BODY$
declare
  ptipomovimientoid alias for $1;
  pfecha alias for $2;
  psocioid alias for $3;
 
  iperiodo integer;
  iejercicio integer;

  fdeposito numeric;
 
begin


  iejercicio:=cast(date_part('year',pfecha) as int);
  iperiodo:=cast(date_part('month',pfecha) as int);

  select sum(mp.debe) into fdeposito
        from movicaja mc, movipolizas mp, polizas p
       where mc.socioid=psocioid and mc.efectivo=1 and
             ( mc.tipomovimientoid in ((select tipomovimientoid from tipomovimiento where tipomovimientoid<>'CI' and ptipomovimientoid<>'AH' and  tipomovimientoid<>'RE' and aplicasaldo='S') union (select (case when exists (select socioid from datosfiscales where socioid =psocioid) then '**' else '00' end) ))) and
             p.polizaid = mc.polizaid and
             mp.movipolizaid=mc.movipolizaid and
             p.ejercicio=iejercicio and p.periodo=iperiodo ;

  fdeposito:=coalesce(fdeposito,0);

return fdeposito;

end
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
