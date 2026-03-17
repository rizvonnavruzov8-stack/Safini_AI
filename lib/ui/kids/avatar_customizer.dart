class AvatarCustomizer extends ConsumerWidget {
  const AvatarCustomizer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Avatar'),
        centerTitle: true,
        actions: [_buildCoinBadge(1250)],
      ),
      body: Column(
        children: [
          _buildPreviewBox(),
          _buildCategoryTabs(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, 
                mainAxisSpacing: 15, 
                crossAxisSpacing: 15
              ),
              itemCount: 6,
              itemBuilder: (context, index) => _buildItemCard(index),
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildItemCard(int index) {
    bool isEquipped = index == 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isEquipped ? AppTheme.primaryColor : AppTheme.slate100, width: isEquipped ? 3 : 1),
      ),
      child: Stack(
        children: [
          const Center(child: Icon(Icons.checkroom, color: AppTheme.slate500, size: 40)),
          if (isEquipped) 
            const Positioned(top: 4, right: 4, child: Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 20)),
        ],
      ),
    );
  }
  
  Widget _buildSaveButton() {
     return Padding(
       padding: const EdgeInsets.all(20),
       child: ElevatedButton(
         onPressed: () {},
         style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
         child: const Text('Save My Look!'),
       ),
     );
  }
}