class GuidelineTitles {
  static String getGuidelineTitle(int pageNo) {
    switch (pageNo) {
      case 0:
        return "Tired of waiting\nin long queues just to buy\n few items?";

      case 1:
        return "Always forget the\n most important thing on your\ngrocery list?";

      case 2:
        return "Now order all\nyour groceries online from\nanywhere anytime";

      case 3:
        return "Select from a\nwide variety of available\nproducts";

      case 4:
        return "Receive your products\nright on your doorsteps\n inside 2 hours.";

      default:
        return 'Quick Grocery Delivery';
    }
  }
}
