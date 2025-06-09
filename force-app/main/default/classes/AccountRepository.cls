public with sharing class AccountRepository {

    /**
     * Retorna lista de contas cujo nome corresponde exatamente ao parâmetro (case-insensitive).
     */
    public static List<Account> findByExactName(String nome) {
        List<Account> contas = [SELECT Id, Name FROM Account];
        List<Account> resultado = new List<Account>();
        for (Account acc : contas) {
            if (acc.Name != null && acc.Name.toLowerCase() == nome.toLowerCase()) {
                resultado.add(acc);
            }
        }
        return resultado;
    }

    /**
     * Retorna contas cujo nome contenha o termo especificado (sensível a maiúsculas).
     */
    public static List<Account> findByNameContains(String termo) {
        return [SELECT Id, Name FROM Account WHERE Name LIKE :('%' + termo + '%')];
    }

    /**
     * Retorna todas as contas (para simular LIKE com string vazia).
     */
    public static List<Account> findAllAccounts() {
        return [SELECT Id FROM Account WHERE Name LIKE '%%'];
    }

    /**
     * Retorna contas com salário acima do valor especificado.
     */
    public static List<Account> findBySalaryGreaterThan(Decimal valor) {
        return [SELECT Id FROM Account WHERE Salary__c > :valor];
    }

    /**
     * Retorna contas com salário abaixo do valor especificado.
     */
    public static List<Account> findBySalaryLessThan(Decimal valor) {
        return [SELECT Id FROM Account WHERE Salary__c < :valor];
    }

    /**
     * Retorna contas com salário entre dois valores.
     */
    public static List<Account> findBySalaryBetween(Decimal min, Decimal max) {
        return [SELECT Id FROM Account WHERE Salary__c >= :min AND Salary__c <= :max];
    }

    /**
     * Retorna contas com data de nascimento entre duas datas.
     */
    public static List<Account> findByBirthDateBetween(Date inicio, Date fim) {
        return [SELECT Id FROM Account WHERE Birth_Date__c >= :inicio AND Birth_Date__c <= :fim];
    }

    /**
     * Atualiza os dados de um cliente Account.
     */
    public static void updateAccount(Account contaAtualizada) {
        update contaAtualizada;
    }

    /**
     * Retorna todas as contas com os principais campos.
     */
    public static List<Account> findAll() {
        return [SELECT Id, Name, Salary__c, Birth_Date__c FROM Account];
    }

    /**
     * Retorna contas com valor exato no campo Salary__c.
     */
    public static List<Account> findByIncome(Decimal income) {
        return [SELECT Id, Name, Salary__c FROM Account WHERE Salary__c = :income];
    }

    /**
     * Busca uma conta por ID. Lança exceção se não encontrada.
     */
    public static Account findById(Id id) {
        List<Account> results = [SELECT Id, Name, Salary__c FROM Account WHERE Id = :id LIMIT 1];
        if (results.isEmpty()) throw new ResourceNotFoundException('Account not found');
        return results[0];
    }

    /**
     * Deleta uma conta pelo ID, utilizando findById.
     */
    public static void deleteById(Id id) {
        delete findById(id);
    }

    /**
     * Insere uma nova conta e retorna o registro criado.
     */
    public static Account insertAccount(Account acc) {
        insert acc;
        return acc;
    }
} 
