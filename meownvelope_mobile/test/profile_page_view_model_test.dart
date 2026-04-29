import 'package:flutter_test/flutter_test.dart';
import 'package:meownvelope_mobile/pages/home_pages/profile/profile_page_view_model.dart';



void main() {
  group('ProfilePageViewModel - initial state', () {
    late ProfilePageViewModel viewModel;

    setUp(() {
      viewModel = ProfilePageViewModel();
    });

    test('isLoggedIn defaults to false', () {
      expect(viewModel.isLoggedIn, false);
    });

    test('username defaults to user_name', () {
      expect(viewModel.username, 'user_name');
    });

    test('selectedAvatarIndex defaults to -1', () {
      expect(viewModel.selectedAvatarIndex, -1);
    });
  });
}


