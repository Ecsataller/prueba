'use client';
import { useEffect, useState } from 'react'; import { useParams } from 'next/navigation'; import { supabase } from '@/lib/supabaseClient';
export default function ActivityDetail() {
  const id = (useParams()?.id as string); const [actividad, setActividad] = useState<any>(null);
  const [tecnicos, setTecnicos] = useState<any[]>([]); const [maquinaria, setMaquinaria] = useState<any[]>([]);
  const [fecha, setFecha] = useState<string>(() => new Date().toISOString().slice(0,10)); const [horas, setHoras] = useState<number>(1);
  const [tecnicoId, setTecnicoId] = useState<string>(''); const [maqId, setMaqId] = useState<string>(''); const [operadorId, setOperadorId] = useState<string>('');
  useEffect(() => { (async () => {
    const { data: act } = await supabase.from('vw_actividades_dashboard').select('*').eq('id', id).single(); setActividad(act);
    const { data: tecs } = await supabase.from('tecnicos').select('id,nombre').order('nombre'); setTecnicos(tecs || []);
    const { data: maq } = await supabase.from('maquinaria').select('id,nombre').order('nombre'); setMaquinaria(maq || []);
  })(); }, [id]);
  async function addHora(){ if(!tecnicoId) return alert('Selecciona técnico');
    const { error } = await supabase.from('actividad_personal').insert({ actividadid:id, tecnicoid:tecnicoId, fecha, horas });
    if (error) alert(error.message); else alert('Parte de horas guardado'); }
  async function addMaq(){ if(!maqId) return alert('Selecciona maquinaria');
    const payload:any = { actividadid:id, maquinariaid:maqId, fecha, horas }; if (operadorId) payload.operadorid = operadorId;
    const { error } = await supabase.from('actividad_maquinaria').insert(payload);
    if (error) alert(error.message); else alert('Uso de maquinaria guardado'); }
  if (!actividad) return <div>Cargando…</div>;
  return (<div className="space-y-6">
    <h1 className="text-2xl font-bold">Actividad</h1>
    <div className="rounded border bg-white p-4"><div className="grid grid-cols-2 gap-2 text-sm">
      <div><strong>Nombre:</strong> {actividad.nombre}</div><div><strong>Departamento:</strong> {actividad.departamento_nombre}</div>
      <div><strong>Estado:</strong> {actividad.estado}</div><div><strong>Activo:</strong> {actividad.activo_tag ?? '-'}</div>
      <div><strong>Costo:</strong> ${(actividad.costo_total ?? 0).toFixed(2)}</div></div></div>
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div className="rounded border bg-white p-4 space-y-3"><h2 className="font-semibold">Diario – Horas de personal</h2>
        <div className="flex gap-2 items-center">
          <input className="border p-2" type="date" value={fecha} onChange={e=>setFecha(e.target.value)} />
          <select className="border p-2" value={tecnicoId} onChange={e=>setTecnicoId(e.target.value)}>
            <option value="">Técnico…</option>{tecnicos.map(t=><option key={t.id} value={t.id}>{t.nombre}</option>)}
          </select>
          <input className="border p-2 w-24" type="number" step="0.5" min="0" value={horas} onChange={e=>setHoras(parseFloat(e.target.value))} />
          <button className="px-3 py-2 bg-blue-600 text-white rounded" onClick={addHora}>Agregar</button>
        </div>
      </div>
      <div className="rounded border bg-white p-4 space-y-3"><h2 className="font-semibold">Diario – Maquinaria</h2>
        <div className="flex gap-2 items-center">
          <input className="border p-2" type="date" value={fecha} onChange={e=>setFecha(e.target.value)} />
          <select className="border p-2" value={maqId} onChange={e=>setMaqId(e.target.value)}>
            <option value="">Maquinaria…</option>{maquinaria.map(m=><option key={m.id} value={m.id}>{m.nombre}</option>)}
          </select>
          <select className="border p-2" value={operadorId} onChange={e=>setOperadorId(e.target.value)}>
            <option value="">Operador (opcional)…</option>{tecnicos.map(t=><option key={t.id} value={t.id}>{t.nombre}</option>)}
          </select>
          <input className="border p-2 w-24" type="number" step="0.5" min="0" value={horas} onChange={e=>setHoras(parseFloat(e.target.value))} />
          <button className="px-3 py-2 bg-blue-600 text-white rounded" onClick={addMaq}>Agregar</button>
        </div>
      </div>
    </div>
  </div>);
}