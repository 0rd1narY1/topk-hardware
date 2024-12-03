// 最小堆方法
#include <stdlib.h>
#include <stdio.h>  // for printf
#include <time.h>

// 堆实现
void Swap(int a[], int i, int j) {
    int tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
}

void HeapDown(int a[], int n, int parent) {
    while (1) {
        // 左孩子 l_child
        int l_child = 2 * parent + 1;
        if (l_child >= n) break;

        // 右孩子 r_child （可能不存在）
        int r_child = l_child + 1;

        // less_child 是其中值更小的孩子
        int less_child = l_child;
        if (r_child < n && a[r_child] < a[l_child]) 
            less_child = r_child;
        if (a[parent] <= a[less_child]) //父节点比子节点更小，不用换位置，直接break
            break;
        Swap(a, parent, less_child); //把父节点换为最小的子节点
        parent = less_child;
    }
}

void HeapBuild(int a[], int n)           // 堆化
{
    // 从最后一层父节点，不断下沉堆
    for (int i = (n - 1) / 2; i >= 0; i--) {
        HeapDown(a, n, i);
    }
}

void HeapReplace(int a[], int n, int v)  // 替换堆顶
{
    if (n <= 0) return;
    a[0] = v;
    //从根节点开始依次整理二叉树
    HeapDown(a, n, 0);
}

// 采用最小堆，找出给定数组中的最大的 k 个数
// 输入原大小为 n 的数组 a
// 函数会原地把 k 大数放到 a 的前 k 个
void TopK(int a[], int n, int k) {
    if (n <= 0 || k <= 0 || k > n) return;

    // 前 k 个 数最小堆化
    HeapBuild(a, k);

    // 剩余的 k .. n-1 元素依次和堆顶比较
    for (int i = k; i < n; i++) {
        if (a[i] > a[0]) {
            // 如果比堆顶大，则替换堆顶
            HeapReplace(a, k, a[i]);
        }
    }
}

int main(void) {
    int n, k;
    int *array;
    
    //初始化
    printf("请输入数组长度:");
    scanf("%d",&n);
    printf("请输入k值:");
    scanf("%d",&k);
    array = (int*)malloc(sizeof(int)*n);
    for(int i = 0; i < n; i++)
    {
        printf("请输入第%d个数组元素: ",i);
        scanf("%d",&array[i]);
    }
    printf("数组是:\n");
    for(int i = 0; i < n; i++)
        printf("%d ",array[i]);
    printf("\n");

    struct timespec begin, end; 
    clock_gettime(CLOCK_REALTIME, &begin);
    TopK(array, n, k);
    clock_gettime(CLOCK_REALTIME, &end);

    printf("最大的k个数是:\n");
    for (int i = 0; i < k; i++)
        printf("%d ", array[i]);
    printf("\n");

    long seconds = end.tv_sec - begin.tv_sec;
    long nanoseconds = end.tv_nsec - begin.tv_nsec;
    double elapsed = seconds + nanoseconds*1e-9;
    printf("Time passed: %.10fs\n",elapsed);

    return 0;
}

