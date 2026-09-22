import 'package:flutter/material.dart';
import '../config.dart';
import '../data/cities.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import 'weather_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _weatherService = WeatherService();
  List<CityItem> _suggestions = [];
  String? _error;

  @override void dispose() { _searchController.dispose(); super.dispose(); }

  void _onSearchChanged(String value) {
    final q = value.trim().toLowerCase();
    setState(() => _suggestions = q.isEmpty ? [] : citySuggestions.where((c) =>
      c.displayName.toLowerCase().contains(q) || c.apiName.toLowerCase().contains(q)).take(5).toList());
  }

  Future<void> _openCity(CityItem city) async {
    FocusScope.of(context).unfocus();
    _searchController.text = city.displayName;
    setState(() { _suggestions = []; _error = null; });
    try {
      final weather = await _weatherService.getWeather(city.apiName);
      if (!mounted) return;
      await Navigator.push(context, MaterialPageRoute(builder: (_) => WeatherDetailScreen(weather: weather)));
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _search() async {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) { setState(() => _error = 'Vui lòng nhập tên thành phố.'); return; }
    final exact = citySuggestions.where((c) => c.displayName.toLowerCase() == q || c.apiName.toLowerCase() == q).toList();
    if (exact.isNotEmpty) { await _openCity(exact.first); return; }
    try {
      final weather = await _weatherService.getWeather(_searchController.text);
      if (!mounted) return;
      await Navigator.push(context, MaterialPageRoute(builder: (_) => WeatherDetailScreen(weather: weather)));
    } catch (e) { if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', '')); }
  }

  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFFF8FF),
    body: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(16,18,16,22), children: [
      const SizedBox(height: 2),
      Text('$studentId - Dự báo thời tiết', textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Color(0xFF28242A))),
      const SizedBox(height: 25),
      _buildSearch(),
      if (_suggestions.isNotEmpty) ...[const SizedBox(height: 6), _buildSuggestions()],
      if (_error != null) ...[const SizedBox(height: 8), Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13))],
      const SizedBox(height: 24),
      const Text('Thành phố nổi bật', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 14),
      ...featuredCities.map(_buildWeatherCard),
    ])),
  );

  Widget _buildSearch() => Row(children: [
    Expanded(child: Container(height: 51, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFAAA4AE), width: 1.2)),
      child: TextField(controller: _searchController, onChanged: _onSearchChanged, onSubmitted: (_) => _search(), decoration: const InputDecoration(hintText: 'Nhập tên thành phố (vd: Hà Nội)...', hintStyle: TextStyle(color: Color(0xFF77717C), fontSize: 16), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal:17, vertical:14))))),
    const SizedBox(width:9), SizedBox(width:50,height:50,child: FilledButton(onPressed:_search, style: FilledButton.styleFrom(backgroundColor:const Color(0xFF2196F3),padding:EdgeInsets.zero,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12))), child:const Icon(Icons.search,color:Colors.white,size:29))),
  ]);

  Widget _buildSuggestions() => Container(decoration: BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(12),boxShadow:const [BoxShadow(blurRadius:8,color:Color(0x22000000),offset:Offset(0,2))]), child: Column(children:_suggestions.map((city)=>ListTile(dense:true,leading:const Icon(Icons.location_on_outlined),title:Text(city.displayName),onTap:()=>_openCity(city))).toList()));

  Widget _buildWeatherCard(CityItem city) => FutureBuilder<Weather>(
    future: _weatherService.getWeather(city.apiName),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) return _loadingCard(city);
      if (snapshot.hasError) return _offlineCard(city);
      final weather = snapshot.data!;
      return GestureDetector(onTap:()=>_openCity(city), child:_weatherCard(city.displayName,weather));
    },
  );

  Widget _weatherCard(String name, Weather weather) => Container(
    margin:const EdgeInsets.only(bottom:11), padding:const EdgeInsets.symmetric(horizontal:14,vertical:12),
    decoration:BoxDecoration(color:const Color(0xFFF8F1FA),borderRadius:BorderRadius.circular(17),border:Border.all(color:const Color(0xFFECE5EF)),boxShadow:const [BoxShadow(color:Color(0x14000000),blurRadius:2,offset:Offset(0,1))]),
    child:Row(children:[_weatherIcon(weather.icon),const SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(name,maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800)),const SizedBox(height:2),Text(_capitalize(weather.description),style:const TextStyle(fontSize:14,color:Color(0xFF6F6971)))])),Text('${weather.temperature.toStringAsFixed(1)}°C',style:const TextStyle(fontSize:22,fontWeight:FontWeight.w700,color:Color(0xFF2196F3))) ]),
  );

  Widget _loadingCard(CityItem city) => Container(height:91,margin:const EdgeInsets.only(bottom:11),padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFFF8F1FA),borderRadius:BorderRadius.circular(17)),child:Row(children:[const SizedBox(width:28,height:28,child:CircularProgressIndicator(strokeWidth:3)),const SizedBox(width:14),Expanded(child:Text(city.displayName,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800))),const Text('--.-°C',style:const TextStyle(fontSize:22,fontWeight:FontWeight.w700,color:Color(0xFF2196F3)))]));

  Widget _offlineCard(CityItem city) => GestureDetector(onTap:()=>_openCity(city),child:Container(height:91,margin:const EdgeInsets.only(bottom:11),padding:const EdgeInsets.symmetric(horizontal:14,vertical:12),decoration:BoxDecoration(color:const Color(0xFFF8F1FA),borderRadius:BorderRadius.circular(17)),child:Row(children:[_weatherIcon('01d'),const SizedBox(width:14),Expanded(child:Text(city.displayName,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800))),const Text('--.-°C',style:const TextStyle(fontSize:22,fontWeight:FontWeight.w700,color:Color(0xFF2196F3)))])));

  Widget _weatherIcon(String iconCode) => SizedBox(width:43,height:43,child:Image.network('https://openweathermap.org/img/wn/$iconCode@2x.png',fit:BoxFit.contain,errorBuilder:(_,__,___)=>const Icon(Icons.wb_sunny,color:Color(0xFFF36F45),size:34)));
  String _capitalize(String value) => value.isEmpty ? value : value[0].toUpperCase()+value.substring(1);
}
