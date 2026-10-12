// lab 9.1 & lab 9.2
// import 'package:flutter/material.dart';
//
// import '../models/person_model.dart';
// import '../services/storage_service.dart';
//
// class PersonScreen extends StatefulWidget {
//   const PersonScreen({super.key});
//
//   @override
//   State<PersonScreen> createState() => _PersonScreenState();
// }
//
// class _PersonScreenState extends State<PersonScreen> {
//   final StorageService storageService = StorageService();
//   bool isSaving = false;
//
//   final TextEditingController nameController =
//   TextEditingController();
//
//   final TextEditingController ageController =
//   TextEditingController();
//
//   bool isSingle = false;
//
//
//   List<PersonModel> persons = [];
//
//   bool isLoading = true;
//   String? errorMessage;
//
//   // initState() được gọi một lần khi đối tượng State được khởi tạo.
//   // => đọc dữ liệu khi màn hình xuất hiện
//   @override
//   void initState() {
//     super.initState();
//     loadPersons();
//   }
//
//   Future<void> loadPersons() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });
//
//     try {
//       final loadedPersons = await storageService.readPersons();
//
//       if (!mounted) return;
//
//       setState(() {
//         persons = loadedPersons;
//         isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//
//       setState(() {
//         errorMessage = 'Failed to load persons: $e';
//         isLoading = false;
//       });
//     }
//   }
//
//
//   void addPerson() {
//     final name = nameController.text.trim();
//     final age = int.tryParse(ageController.text.trim());
//
//     // Validate name
//     if (name.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a name'),
//         ),
//       );
//       return;
//     }
//
//     // Validate age
//     if (age == null || age <= 0 || age > 120) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a valid age'),
//         ),
//       );
//       return;
//     }
//
//     // Create PersonModel
//     final newPerson = PersonModel(
//       name: name,
//       age: age,
//       isSingle: isSingle,
//     );
//
//     // Update list in memory
//     setState(() {
//       persons.add(newPerson);
//     });
//
//     // Clear input fields
//     nameController.clear();
//     ageController.clear();
//
//     setState(() {
//       isSingle = false;
//     });
//
//     // Show confirmation
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Person added successfully!'),
//       ),
//     );
//   }
//
//   Future<void> savePersons() async {
//     if (isSaving) return;
//
//     setState(() {
//       isSaving = true;
//     });
//
//     try {
//       await storageService.savePersons(persons);
//
//       if (!mounted) return;
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Data saved successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to save data: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           isSaving = false;
//         });
//       }
//     }
//   }
//
//   Widget buildAddPersonForm() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Add New Person',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Name input
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//                 hintText: 'Enter name',
//                 prefixIcon: Icon(Icons.person),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             // Age input
//             TextField(
//               controller: ageController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Age',
//                 hintText: 'Enter age',
//                 prefixIcon: Icon(Icons.numbers),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             // Single status
//             CheckboxListTile(
//               title: const Text('Is Single?'),
//               value: isSingle,
//               contentPadding: EdgeInsets.zero,
//               onChanged: (value) {
//                 setState(() {
//                   isSingle = value ?? false;
//                 });
//               },
//             ),
//
//             const SizedBox(height: 12),
//
//             // Add button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: addPerson,
//                 icon: const Icon(Icons.add),
//                 label: const Text('Add Person'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildSaveButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         onPressed: isSaving ? null : savePersons,
//         icon: isSaving
//             ? const SizedBox(
//           width: 18,
//           height: 18,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//           ),
//         )
//             : const Icon(Icons.save),
//         label: Text(
//           isSaving ? 'Saving...' : 'Save',
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.green,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(
//             vertical: 16,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Person Manager'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//
//       body: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(),
//       )
//           : errorMessage != null
//           ? Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(errorMessage!),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: loadPersons,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       )
//           : ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Add Person Form
//           buildAddPersonForm(),
//
//           const SizedBox(height: 24),
//
//           Text(
//             'Person List (${persons.length})',
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           if (persons.isEmpty)
//             const Padding(
//               padding: EdgeInsets.all(24),
//               child: Center(
//                 child: Text('No persons found'),
//               ),
//             )
//           else
//             ListView.builder(
//               shrinkWrap: true, // cho phép danh sách con tính chiều cao theo nội dung
//               physics: const NeverScrollableScrollPhysics(), // vô hiệu hoá cuộn riêng của danh sách con
//               itemCount: persons.length,
//               itemBuilder: (context, index) {
//                 final person = persons[index];
//
//                 return Card(
//                   margin: const EdgeInsets.only(
//                     bottom: 12,
//                   ),
//                   child: ListTile(
//                     leading: const CircleAvatar(
//                       child: Icon(Icons.person),
//                     ),
//                     title: Text(
//                       person.name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Text(
//                       'Age: ${person.age}',
//                     ),
//                     trailing: Text(
//                       person.isSingle
//                           ? 'Single'
//                           : 'Not Single',
//                       style: TextStyle(
//                         color: person.isSingle
//                             ? Colors.green
//                             : Colors.grey,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           const SizedBox(height: 24),
//
//           buildSaveButton(),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     ageController.dispose();
//     super.dispose();
//   }
// }


// lab 9.3:

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/person_model.dart';
import '../services/storage_service.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  final StorageService storageService = StorageService();

  final TextEditingController searchController =
  TextEditingController();

  List<PersonModel> persons = [];

  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  String searchQuery = '';

  // STEP 1: Load data from JSON
  @override
  void initState() {
    super.initState();
    loadPersons();
  }

  Future<void> loadPersons() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await storageService.readPersons();

      if (!mounted) return;

      setState(() {
        persons = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // STEP 2: Search
  List<PersonModel> get filteredPersons {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) return persons;

    return persons.where((person) {
      return person.name.toLowerCase().contains(query) ||
          person.id.toLowerCase().contains(query);
    }).toList();
  }

  // STEP 4: Auto-save
  Future<void> persistPersons() async {
    setState(() {
      isSaving = true;
    });

    try {
      await storageService.savePersons(persons);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // STEP 3: Add / Edit dialog
  Future<void> showPersonDialog({
    PersonModel? person,
  }) async {
    final nameController = TextEditingController(
      text: person?.name ?? '',
    );

    final ageController = TextEditingController(
      text: person?.age.toString() ?? '',
    );

    bool isSingle = person?.isSingle ?? false;

    final result = await showDialog<PersonModel>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                person == null ? 'Add Person' : 'Edit Person',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    CheckboxListTile(
                      title: const Text('Is Single?'),
                      value: isSingle,
                      onChanged: (value) {
                        setDialogState(() {
                          isSingle = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name =
                    nameController.text.trim();
                    final age = int.tryParse(
                      ageController.text.trim(),
                    );

                    if (name.isEmpty ||
                        age == null ||
                        age <= 0 ||
                        age > 120) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Enter a valid name and age',
                          ),
                        ),
                      );
                      return;
                    }

                    final result = person == null
                        ? PersonModel(
                      id: const Uuid().v4(),
                      name: name,
                      age: age,
                      isSingle: isSingle,
                    )
                        : person.copyWith(
                      name: name,
                      age: age,
                      isSingle: isSingle,
                    );

                    Navigator.pop(dialogContext, result);
                  },
                  child: Text(
                    person == null ? 'Add' : 'Update',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    ageController.dispose();

    if (!mounted || result == null) return;

    if (person == null) {
      setState(() {
        persons.add(result);
      });
    } else {
      setState(() {
        final index = persons.indexWhere(
              (item) => item.id == person.id,
        );

        if (index != -1) {
          persons[index] = result;
        }
      });
    }

    await persistPersons();
  }

  // STEP 3: Delete with confirmation
  Future<void> deletePerson(PersonModel person) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Person'),
          content: Text(
            'Are you sure you want to delete ${person.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      persons.removeWhere(
            (item) => item.id == person.id,
      );
    });

    await persistPersons();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // STEP 5: UI
  @override
  Widget build(BuildContext context) {
    final displayedPersons = filteredPersons;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Person Manager'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isLoading || isSaving
            ? null
            : () => showPersonDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Person'),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : errorMessage != null
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $errorMessage'),
            ElevatedButton(
              onPressed: loadPersons,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search persons',
                hintText: 'Name or ID',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: displayedPersons.isEmpty
                ? Center(
              child: Text(
                searchQuery.isEmpty
                    ? 'No persons found'
                    : 'No matching persons',
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 90,
              ),
              itemCount:
              displayedPersons.length,
              itemBuilder: (context, index) {
                final person =
                displayedPersons[index];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        person.name[0]
                            .toUpperCase(),
                      ),
                    ),
                    title: Text(
                      person.name,
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Age: ${person.age}\n'
                          '${person.isSingle ? "Single" : "Not Single"}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: isSaving
                              ? null
                              : () =>
                              showPersonDialog(
                                person: person,
                              ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: isSaving
                              ? null
                              : () =>
                              deletePerson(
                                person,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

