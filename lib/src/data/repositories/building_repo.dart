part of 'repositories.dart';

class BuildingRepo {
  late String statusCode;

  getBuilding() async {
    statusCode = "";
    try {
      QuerySnapshot resultBuilding =
          await Repositories().db.collection("buildings").get();
      if (resultBuilding.docs.isNotEmpty) {
        statusCode = "200";
        final List<BuildingModel> buildings =
            resultBuilding.docs.map((e) => BuildingModel.fromJson(e)).toList();
        return buildings;
      } else {
        statusCode = "200";
        final List<BuildingModel> buildings = [];
        return buildings;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  getBuildingAvail(String dateStart) async {
    statusCode = "";
    try {
      QuerySnapshot resultBuilding =
          await Repositories().db.collection("buildings").get();
      if (resultBuilding.docs.isNotEmpty) {
        statusCode = "200";
        final List<BuildingModel> buildings =
            resultBuilding.docs.map((e) => BuildingModel.fromJson(e)).toList();
        final buildingAvail = buildings
            .where(
              (element) =>
                  element.status == "Tersedia" ||
                  DateTime.parse(element.usedUntil!).isBefore(
                    DateTime.parse(dateStart),
                  ),
            )
            .toList();
        return buildingAvail;
      } else {
        statusCode = "200";
        final List<BuildingModel> buildings = [];
        return buildings;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}