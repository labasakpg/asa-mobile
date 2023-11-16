import 'package:anugerah_mobile/cons/enums.dart';

class EmployeeStakeHolderStateConverter {
  EmployeeStakeHolderStateConverter._();

  static const String undefineState = "-";

  static String toLabel(EmployeeStakeHolderState state) {
    switch (state) {
      case EmployeeStakeHolderState.doctor:
        return "Dokter";
      case EmployeeStakeHolderState.institute:
        return "Perusahaan";
      default:
        return undefineState;
    }
  }

  static String toTileLabel(EmployeeStakeHolderState state) {
    switch (state) {
      case EmployeeStakeHolderState.doctor:
        return "Dokter      ";
      case EmployeeStakeHolderState.institute:
        return "PIC            ";
      default:
        return "";
    }
  }

  static EmployeeStakeHolderState fromLabel(String state) {
    switch (state) {
      case "Perusahaan":
        return EmployeeStakeHolderState.institute;
      case "Dokter":
      default:
        return EmployeeStakeHolderState.doctor;
    }
  }

  static String toLabel2(String state) {
    return state == "Dokter" ? state : "PIC";
  }

  static String toKey(EmployeeStakeHolderState state) {
    switch (state) {
      case EmployeeStakeHolderState.doctor:
        return "doctors";
      case EmployeeStakeHolderState.institute:
        return "institutes";
      default:
        return undefineState;
    }
  }

  static List<String> toOptions() {
    return ["Dokter", "Perusahaan"];
  }
}
