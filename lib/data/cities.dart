class CityItem {
  final String apiName;
  final String displayName;
  const CityItem(this.apiName, this.displayName);
}

const List<CityItem> featuredCities = [
  CityItem('Hanoi', 'Hà Nội'),
  CityItem('Ho Chi Minh City', 'Thành phố Hồ Chí Minh'),
  CityItem('Da Nang', 'Đà Nẵng'),
  CityItem('Tokyo', 'Tokyo'),
  CityItem('Paris', 'Paris'),
  CityItem('New York', 'Thành phố New York'),
];

const List<CityItem> citySuggestions = [
  ...featuredCities,
  CityItem('Hue', 'Huế'), CityItem('Nha Trang', 'Nha Trang'),
  CityItem('Vung Tau', 'Vũng Tàu'), CityItem('Da Lat', 'Đà Lạt'),
  CityItem('Can Tho', 'Cần Thơ'), CityItem('Hai Phong', 'Hải Phòng'),
  CityItem('London', 'London'), CityItem('Seoul', 'Seoul'),
  CityItem('Singapore', 'Singapore'),
];
