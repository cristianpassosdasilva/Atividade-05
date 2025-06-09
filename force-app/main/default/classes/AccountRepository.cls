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
} 
