CREATE OR REPLACE FUNCTION verificacomisionprestamo(int4, int4, numeric)
  RETURNS SETOF rcomision AS $BODY$
declare
  pprestamoid alias for $1;
  ptipocobro alias for $2;
  pbonifica alias for $3;
  
  r rcomision%rowtype;
   
  fcomision numeric;
  itipocobrocomision integer;
 
  fmontoprestamo numeric;
  pporcentaje numeric;
  ptipoprestamoid char(3);
  fsaldoprestamo numeric;
  fiva numeric;
  fperiodicidad integer;
  nedad integer;
begin

--comision                
--tipocobrocomision 0= al otorgamiento, 1 ala primera amortizacion, 2 al vencimiento.

select iva into fiva from empresa;

select montoprestamo,tipoprestamoid,saldoprestamo, (case when dias_de_cobro > 0 then dias_de_cobro else meses_de_cobro * 30 end) into fmontoprestamo,ptipoprestamoid,fsaldoprestamo,fperiodicidad from prestamos where prestamoid=pprestamoid;

select porcentaje into pporcentaje from cargoprestamo where tipoprestamoid = ptipoprestamoid and apertura=1 and tipocargo = 0 and fmontoprestamo > rangoinicial and fmontoprestamo < rangofinal;

select substr(age(fecha_nacimiento),1,2) into nedad from sujeto su, socio s, prestamos p  where su.sujetoid=s.sujetoid and s.socioid=p.socioid and p.prestamoid=pprestamoid;

pporcentaje := coalesce(pporcentaje,0);


if (ptipocobro=0 and fsaldoprestamo=fmontoprestamo) and nedad<=67 then
 
   r.comision=pporcentaje/100*fmontoprestamo;  
   r.comision=round(r.comision-pbonifica,2);
   r.ivacomision=round(r.comision*fiva,2);
   
else

   r.comision:=0;
   r.ivacomision:=0;
   
end if;

return next r;

end
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
