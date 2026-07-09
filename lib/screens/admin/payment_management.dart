import 'package:flutter/material.dart';
import '../../models/payment.dart';
import '../../services/data_service.dart';
import '../../constants/colors.dart';

class PaymentManagement extends StatefulWidget {
  const PaymentManagement({super.key});

  @override
  _PaymentManagementState createState() => _PaymentManagementState();
}

class _PaymentManagementState extends State<PaymentManagement> {
  final DataService data = DataService();
  List<Payment> _filteredPayments = [];
  String _searchQuery = '';
  String _selectedStatus = 'Tous';

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredPayments = data.payments.where((p) {
        final student = data.getStudent(p.studentId);
        bool matchSearch = student?.fullName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ??
            false;
        bool matchStatus =
            _selectedStatus == 'Tous' || p.status == _selectedStatus;
        return matchSearch && matchStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final statuses = ['Tous', 'paid', 'unpaid', 'partial'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Paiements'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPaymentForm(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher par étudiant...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onChanged: (val) {
                      _searchQuery = val;
                      _applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedStatus,
                    underline: const SizedBox(),
                    items: statuses
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (val) {
                      _selectedStatus = val!;
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredPayments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment,
                            size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 10),
                        Text('Aucun paiement trouvé',
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _filteredPayments.length,
                    itemBuilder: (ctx, i) {
                      final payment = _filteredPayments[i];
                      final student = data.getStudent(payment.studentId);
                      final statusColor = payment.status == 'paid'
                          ? Colors.green
                          : payment.status == 'partial'
                              ? Colors.orange
                              : Colors.red;

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                payment.status == 'paid'
                                    ? Icons.check_circle
                                    : payment.status == 'partial'
                                        ? Icons.credit_card
                                        : Icons.cancel,
                                color: statusColor,
                                size: 30,
                              ),
                            ),
                          ),
                          title: Text(
                            student?.fullName ?? 'Étudiant inconnu',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Montant: ${payment.amount.toStringAsFixed(0)} FBu'),
                              Text(
                                'Statut: ${payment.status.toUpperCase()}',
                                style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: AppColors.primary),
                                onPressed: () =>
                                    _showPaymentForm(payment: payment),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deletePayment(payment.id),
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

  void _showPaymentForm({Payment? payment}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentForm(
        payment: payment,
        onSave: () => _applyFilters(),
      ),
    );
  }

  void _deletePayment(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer ce paiement ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              data.deletePayment(id);
              Navigator.pop(context);
              _applyFilters();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Paiement supprimé avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class PaymentForm extends StatefulWidget {
  final Payment? payment;
  final VoidCallback onSave;
  const PaymentForm({super.key, this.payment, required this.onSave});

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedStudentId;
  String _selectedStatus = 'unpaid';
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.payment != null;
    if (widget.payment != null) {
      _amountController.text = widget.payment!.amount.toString();
      _descriptionController.text = widget.payment!.description;
      _selectedStudentId = widget.payment!.studentId;
      _selectedStatus = widget.payment!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = DataService();
    final students = data.students;

    return AlertDialog(
      title: Row(
        children: [
          Icon(_isEdit ? Icons.edit : Icons.payment, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(_isEdit ? 'Modifier paiement' : 'Ajouter paiement'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedStudentId,
                decoration: InputDecoration(
                  labelText: 'Étudiant',
                  prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: students
                    .map((s) => DropdownMenuItem(
                          value: s.id,
                          child: Text(s.fullName),
                        ))
                    .toList(),
                validator: (v) => v == null ? 'Requis' : null,
                onChanged: (val) => setState(() => _selectedStudentId = val),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Montant (FBu)',
                  prefixIcon: const Icon(Icons.money, color: AppColors.primary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Statut',
                  prefixIcon: const Icon(Icons.info, color: AppColors.primary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: ['paid', 'unpaid', 'partial']
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedStatus = val!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.description, color: AppColors.primary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _savePayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(_isEdit ? 'Modifier' : 'Ajouter'),
        ),
      ],
    );
  }

  void _savePayment() {
    if (_formKey.currentState!.validate()) {
      final data = DataService();
      if (_isEdit) {
        final updated = Payment(
          id: widget.payment!.id,
          studentId: _selectedStudentId!,
          amount: double.parse(_amountController.text),
          date: widget.payment!.date,
          status: _selectedStatus,
          description: _descriptionController.text,
        );
        data.updatePayment(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Paiement modifié avec succès'),
              backgroundColor: Colors.green),
        );
      } else {
        final newPayment = Payment(
          id: data.generatePaymentId(),
          studentId: _selectedStudentId!,
          amount: double.parse(_amountController.text),
          date: DateTime.now(),
          status: _selectedStatus,
          description: _descriptionController.text,
        );
        data.addPayment(newPayment);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Paiement ajouté avec succès'),
              backgroundColor: Colors.green),
        );
      }
      Navigator.pop(context);
      widget.onSave();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
